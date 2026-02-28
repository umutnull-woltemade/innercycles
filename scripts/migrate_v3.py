#!/usr/bin/env python3
"""
Smart isEn -> L10nService migration v3.
Uses ref.read(languageProvider) — works in any method of ConsumerStatefulWidget.
Only processes ConsumerStatefulWidget/ConsumerWidget files.
"""

import json, os, re
from pathlib import Path
from collections import OrderedDict

PROJECT_ROOT = Path(__file__).parent.parent
LIB_DIR = PROJECT_ROOT / "lib"
EN_JSON = PROJECT_ROOT / "assets" / "l10n" / "en.json"
TR_JSON = PROJECT_ROOT / "assets" / "l10n" / "tr.json"

new_en_keys = {}
new_tr_keys = {}
key_counter = {}
total_replacements = 0
files_modified = 0
skipped_interpolation = 0


def sanitize_key(s):
    s = s.lower().strip()
    s = re.sub(r'[^a-z0-9_\s]', '', s)
    s = re.sub(r'\s+', '_', s)
    s = s[:40].rstrip('_')
    return s or 'text'


def file_to_prefix(filepath):
    rel = os.path.relpath(filepath, LIB_DIR)
    parts = rel.replace('.dart', '').split(os.sep)
    skip = {'presentation', 'widgets', 'lib'}
    parts = [p for p in parts if p not in skip]
    if parts and parts[0] == 'features':
        parts = parts[1:]
    elif parts and parts[0] in ('shared', 'data', 'core'):
        pass
    if parts:
        last = parts[-1]
        for suffix in ['_screen', '_section', '_card', '_widget', '_modal', '_banner', '_sheet', '_dialog']:
            last = last.replace(suffix, '')
        parts[-1] = last
    return '.'.join(parts)


def make_unique_key(prefix, en_text):
    desc = sanitize_key(en_text[:50])
    base_key = f"{prefix}.{desc}" if desc else f"{prefix}.text"
    if base_key not in key_counter:
        key_counter[base_key] = 0
        return base_key
    else:
        key_counter[base_key] += 1
        return f"{base_key}_{key_counter[base_key]}"


def is_consumer_file(content):
    return 'ConsumerWidget' in content or 'ConsumerStatefulWidget' in content


ISEN_PATTERN = re.compile(
    r"""isEn\s*\?\s*'((?:[^'\\]|\\.)*)'\s*:\s*'((?:[^'\\]|\\.)*)'"""
)


def process_file(filepath):
    global total_replacements, files_modified, skipped_interpolation

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'isEn' not in content:
        return
    if not is_consumer_file(content):
        return

    has_l10n_import = 'l10n_service' in content
    has_app_providers_import = 'app_providers' in content
    prefix = file_to_prefix(filepath)
    original_content = content
    replacements = []

    # Determine what language expression to use
    # If file has `final language = ref.watch(languageProvider)` in build(),
    # then methods called FROM build have `language` in outer scope only if
    # the method is defined within build (closures). For separate methods, use ref.read.
    # Safest: always use `ref.read(languageProvider)`
    lang_expr = 'ref.read(languageProvider)'

    for match in ISEN_PATTERN.finditer(content):
        full_match = match.group(0)
        en_text = match.group(1)
        tr_text = match.group(2)

        if '$' in en_text or '$' in tr_text:
            skipped_interpolation += 1
            continue
        if len(en_text) < 2 and len(tr_text) < 2:
            continue

        key = make_unique_key(prefix, en_text)
        new_en_keys[key] = en_text
        new_tr_keys[key] = tr_text
        replacement = f"L10nService.get('{key}', {lang_expr})"
        replacements.append((full_match, replacement))

    if not replacements:
        return

    for old, new in replacements:
        content = content.replace(old, new, 1)
        total_replacements += 1

    if content != original_content:
        files_modified += 1

        # Add imports if needed
        lines = content.split('\n')
        last_import_idx = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                last_import_idx = i

        imports_to_add = []
        if not has_l10n_import:
            rel_path = os.path.relpath(
                LIB_DIR / 'data' / 'services' / 'l10n_service.dart',
                os.path.dirname(filepath)
            )
            imports_to_add.append(f"import '{rel_path}';")

        for imp in imports_to_add:
            if imp not in content:
                lines.insert(last_import_idx + 1, imp)
                last_import_idx += 1

        content = '\n'.join(lines)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"  [{len(replacements):3d}] {os.path.relpath(filepath, PROJECT_ROOT)}")


def set_nested_key(d, key, value):
    parts = key.split('.')
    current = d
    for part in parts[:-1]:
        if part not in current:
            current[part] = OrderedDict()
        elif not isinstance(current[part], dict):
            current[part] = OrderedDict()
        current = current[part]
    current[parts[-1]] = value


def update_json_files():
    with open(EN_JSON, 'r', encoding='utf-8') as f:
        en_data = json.load(f, object_pairs_hook=OrderedDict)
    with open(TR_JSON, 'r', encoding='utf-8') as f:
        tr_data = json.load(f, object_pairs_hook=OrderedDict)

    added = 0
    for key in sorted(new_en_keys.keys()):
        en_text = new_en_keys[key]
        tr_text = new_tr_keys.get(key, en_text)
        parts = key.split('.')
        existing = en_data
        found = True
        for part in parts:
            if isinstance(existing, dict) and part in existing:
                existing = existing[part]
            else:
                found = False
                break
        if not found:
            set_nested_key(en_data, key, en_text)
            set_nested_key(tr_data, key, tr_text)
            added += 1

    with open(EN_JSON, 'w', encoding='utf-8') as f:
        json.dump(en_data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    with open(TR_JSON, 'w', encoding='utf-8') as f:
        json.dump(tr_data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    print(f"\n  Added {added} keys to en.json + tr.json")


def main():
    print("=" * 60)
    print("InnerCycles: isEn -> L10nService Migration v3")
    print("Uses ref.read(languageProvider) — safe in all methods")
    print("=" * 60)

    dart_files = []
    for root, dirs, files in os.walk(LIB_DIR):
        if '_archived' in root:
            continue
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    dart_files.sort()

    print(f"\nScanning {len(dart_files)} files...\n")
    for filepath in dart_files:
        process_file(filepath)

    if new_en_keys:
        print(f"\nUpdating JSON...")
        update_json_files()

    print(f"\n{'=' * 60}")
    print(f"Files:       {files_modified}")
    print(f"Replaced:    {total_replacements}")
    print(f"L10n keys:   {len(new_en_keys)}")
    print(f"Skipped ($): {skipped_interpolation}")
    print(f"{'=' * 60}")


if __name__ == '__main__':
    main()
