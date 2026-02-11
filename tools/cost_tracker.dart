// ignore_for_file: avoid_print
// Cost Tracker — AI Token Budget Management
//
// Tracks token usage and costs across agent runs.
// Enforces budget guardrails per agent, cycle, week, and month.
//
// Usage: dart run tools/cost_tracker.dart [command] [args]
// Commands:
//   log [agent] [model] [input_tokens] [output_tokens]
//   report
//   check [scope]  (agent|cycle|weekly|monthly)
//   reset

import 'dart:io';
import 'dart:convert';

const String costLogFile = '.cost_log.json';

// Model pricing per 1M tokens
const Map<String, (double input, double output)> modelPricing = {
  'claude-opus-4-6': (15.0, 75.0),
  'claude-sonnet-4-5': (3.0, 15.0),
  'claude-haiku-4-5': (0.25, 1.25),
  'ollama/llama3.1:8b': (0.0, 0.0),
  'ollama/mistral:7b': (0.0, 0.0),
};

// Budget limits
const double agentLimit = 2.0;
const double cycleLimit = 10.0;
const double weeklyLimit = 50.0;
const double monthlyLimit = 200.0;
const double weeklyWarning = 40.0;
const double monthlyWarning = 160.0;

class CostEntry {
  final String timestamp;
  final String agent;
  final String model;
  final int inputTokens;
  final int outputTokens;
  final double cost;

  CostEntry({
    required this.timestamp,
    required this.agent,
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    required this.cost,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'agent': agent,
        'model': model,
        'input_tokens': inputTokens,
        'output_tokens': outputTokens,
        'cost_usd': cost,
      };

  factory CostEntry.fromJson(Map<String, dynamic> json) => CostEntry(
        timestamp: json['timestamp'] as String,
        agent: json['agent'] as String,
        model: json['model'] as String,
        inputTokens: json['input_tokens'] as int,
        outputTokens: json['output_tokens'] as int,
        cost: (json['cost_usd'] as num).toDouble(),
      );
}

double computeCost(String model, int inputTokens, int outputTokens) {
  final pricing = modelPricing[model];
  if (pricing == null) return 0.0;

  final inputCost = (inputTokens / 1000000) * pricing.$1;
  final outputCost = (outputTokens / 1000000) * pricing.$2;
  return inputCost + outputCost;
}

List<CostEntry> loadLog() {
  final file = File(costLogFile);
  if (!file.existsSync()) return [];

  try {
    final json = jsonDecode(file.readAsStringSync());
    return (json['entries'] as List)
        .map((e) => CostEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return [];
  }
}

void saveLog(List<CostEntry> entries) {
  final file = File(costLogFile);
  file.writeAsStringSync(jsonEncode({
    'entries': entries.map((e) => e.toJson()).toList(),
  }));
}

void logUsage(String agent, String model, int inputTokens, int outputTokens) {
  final cost = computeCost(model, inputTokens, outputTokens);
  final entry = CostEntry(
    timestamp: DateTime.now().toUtc().toIso8601String(),
    agent: agent,
    model: model,
    inputTokens: inputTokens,
    outputTokens: outputTokens,
    cost: cost,
  );

  final entries = loadLog()..add(entry);
  saveLog(entries);

  print('Logged: $agent | $model | ${inputTokens}in/${outputTokens}out | \$${cost.toStringAsFixed(4)}');
}

void printReport() {
  final entries = loadLog();
  if (entries.isEmpty) {
    print('No cost entries logged.');
    return;
  }

  final total = entries.fold<double>(0, (sum, e) => sum + e.cost);
  final totalInput = entries.fold<int>(0, (sum, e) => sum + e.inputTokens);
  final totalOutput = entries.fold<int>(0, (sum, e) => sum + e.outputTokens);

  // Per-agent breakdown
  final byAgent = <String, double>{};
  for (final e in entries) {
    byAgent[e.agent] = (byAgent[e.agent] ?? 0) + e.cost;
  }

  // Per-model breakdown
  final byModel = <String, double>{};
  for (final e in entries) {
    byModel[e.model] = (byModel[e.model] ?? 0) + e.cost;
  }

  print('╔══════════════════════════════════════════════════════╗');
  print('║           COST REPORT — Token Budget                ║');
  print('╚══════════════════════════════════════════════════════╝');
  print('');
  print('Total entries: ${entries.length}');
  print('Total tokens: ${totalInput}in / ${totalOutput}out');
  print('Total cost: \$${total.toStringAsFixed(4)}');
  print('');
  print('── By Agent ──');
  for (final entry in byAgent.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
    print('  ${entry.key}: \$${entry.value.toStringAsFixed(4)}');
  }
  print('');
  print('── By Model ──');
  for (final entry in byModel.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
    print('  ${entry.key}: \$${entry.value.toStringAsFixed(4)}');
  }
  print('');
  print('── Budget Status ──');
  print('  Monthly: \$${total.toStringAsFixed(2)} / \$$monthlyLimit (${(total / monthlyLimit * 100).toStringAsFixed(1)}%)');
}

void checkBudget(String scope) {
  final entries = loadLog();
  final now = DateTime.now().toUtc();

  double total;
  double limit;

  switch (scope) {
    case 'monthly':
      total = entries
          .where((e) => DateTime.parse(e.timestamp).month == now.month)
          .fold(0.0, (sum, e) => sum + e.cost);
      limit = monthlyLimit;
    case 'weekly':
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      total = entries
          .where((e) => DateTime.parse(e.timestamp).isAfter(weekStart))
          .fold(0.0, (sum, e) => sum + e.cost);
      limit = weeklyLimit;
    case 'cycle':
      total = entries.fold(0.0, (sum, e) => sum + e.cost);
      limit = cycleLimit;
    default:
      print('Unknown scope: $scope');
      exit(1);
  }

  final pct = (total / limit * 100);

  print('$scope budget: \$${total.toStringAsFixed(4)} / \$$limit (${pct.toStringAsFixed(1)}%)');

  if (total >= limit) {
    print('🛑 HARD STOP — $scope budget exceeded!');
    exit(1);
  } else if (pct >= 80) {
    print('⚠️  WARNING — $scope budget at ${pct.toStringAsFixed(0)}%');
    exit(0);
  } else {
    print('✅ OK');
    exit(0);
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run tools/cost_tracker.dart <command> [args]');
    print('Commands: log, report, check, reset');
    exit(1);
  }

  switch (args[0]) {
    case 'log':
      if (args.length < 5) {
        print('Usage: log <agent> <model> <input_tokens> <output_tokens>');
        exit(1);
      }
      logUsage(args[1], args[2], int.parse(args[3]), int.parse(args[4]));
    case 'report':
      printReport();
    case 'check':
      checkBudget(args.length > 1 ? args[1] : 'monthly');
    case 'reset':
      File(costLogFile).writeAsStringSync('{"entries":[]}');
      print('Cost log reset.');
    default:
      print('Unknown command: ${args[0]}');
      exit(1);
  }
}
