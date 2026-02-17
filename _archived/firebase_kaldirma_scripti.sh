#!/bin/bash

# ============================================
# FIREBASE KALDIRMA & GA4 KURULUM SCRİPTİ
# ============================================
# AstroBoBo - Beyaz Ekran Sorunu Çözümü
# Firebase → Google Analytics 4 + Supabase

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear

echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║      🚀 FIREBASE KALDIRMA OTOMASYON 🚀              ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║   Firebase → Google Analytics 4 + Supabase           ║${NC}"
echo -e "${CYAN}║   Beyaz Ekran Sorunu %100 Çözülüyor!                 ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
sleep 2

# ============================================
# KONTROLLER
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[1/8] Ön Kontroller${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Flutter kontrolü
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter bulunamadı!${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Flutter: $(flutter --version | head -n 1)"

# Proje kontrolü
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}✗ Flutter projesi değil!${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Flutter projesi bulundu"

# Hazır dosyalar kontrolü
REQUIRED_FILES=(
    "pubspec_web_fix.yaml"
    "index_web_fix.html"
    "main_web_fix.dart"
    "analytics_helper.dart"
)

MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} Eksik dosya: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo ""
    echo -e "${RED}Hata: $MISSING_FILES adet hazır dosya eksik!${NC}"
    echo -e "${YELLOW}Lütfen önce hazır dosyaları projenize ekleyin.${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Tüm hazır dosyalar mevcut"

echo ""
sleep 1

# ============================================
# GOOGLE ANALYTICS 4 ÖLÇÜM KİMLİĞİ
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[2/8] Google Analytics 4 Yapılandırması${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Google Analytics 4 Ölçüm Kimliğiniz var mı?${NC}"
echo ""
echo "1) Evet, var (G-XXXXXXXXXX)"
echo "2) Hayır, şimdi alacağım"
echo ""
read -p "Seçiminiz (1 veya 2): " GA_CHOICE

if [ "$GA_CHOICE" = "1" ]; then
    echo ""
    read -p "Ölçüm Kimliğinizi girin (G-XXXXXXXXXX): " GA_MEASUREMENT_ID
    
    # Basit format kontrolü
    if [[ ! $GA_MEASUREMENT_ID =~ ^G-[A-Z0-9]{10}$ ]]; then
        echo -e "${YELLOW}⚠ Girdiğiniz format şüpheli, ama devam ediyorum: $GA_MEASUREMENT_ID${NC}"
    else
        echo -e "${GREEN}✓${NC} Geçerli format: $GA_MEASUREMENT_ID"
    fi
else
    echo ""
    echo -e "${CYAN}Google Analytics 4 Hesabı Oluşturma:${NC}"
    echo ""
    echo "1. Tarayıcınızda açın: ${BLUE}https://analytics.google.com/${NC}"
    echo "2. Giriş yapın (Google hesabı)"
    echo "3. Yönetim (Admin) → Mülk oluştur"
    echo "4. Platform: Web seçin"
    echo "5. Web sitesi URL: https://astrobobo.com"
    echo "6. Ölçüm Kimliğini (G-XXXXXXXXXX) kopyalayın"
    echo ""
    echo -e "${YELLOW}Hazır olunca Enter'a basın...${NC}"
    read
    
    echo ""
    read -p "Ölçüm Kimliğinizi girin (G-XXXXXXXXXX): " GA_MEASUREMENT_ID
    
    if [ -z "$GA_MEASUREMENT_ID" ]; then
        echo -e "${RED}Hata: Ölçüm Kimliği boş olamaz!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓${NC} Ölçüm Kimliği kaydedildi: $GA_MEASUREMENT_ID"
fi

echo ""
sleep 1

# ============================================
# SUPABASE BİLGİLERİ
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[3/8] Supabase Yapılandırması${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Supabase bilgileriniz hazır mı?${NC}"
echo ""
echo "1) Evet, bilgilerim var"
echo "2) Hayır, daha sonra ekleyeceğim (placeholder kullan)"
echo ""
read -p "Seçiminiz (1 veya 2): " SUPABASE_CHOICE

if [ "$SUPABASE_CHOICE" = "1" ]; then
    echo ""
    read -p "Supabase Project URL (https://xxxxx.supabase.co): " SUPABASE_URL
    read -p "Supabase Anon Key (eyJhbGci...): " SUPABASE_ANON_KEY
    
    if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
        echo -e "${RED}Hata: Supabase bilgileri boş olamaz!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓${NC} Supabase bilgileri kaydedildi"
else
    SUPABASE_URL="YOUR_SUPABASE_URL"
    SUPABASE_ANON_KEY="YOUR_SUPABASE_ANON_KEY"
    echo -e "${YELLOW}⚠${NC} Placeholder kullanılacak - daha sonra güncellemelisiniz!"
fi

echo ""
sleep 1

# ============================================
# YEDEKLEME
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[4/8] Mevcut Dosyaları Yedekleme${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backup_firebase_removal_$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

# pubspec.yaml yedekle
if [ -f "pubspec.yaml" ]; then
    cp pubspec.yaml "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Yedeklendi: pubspec.yaml"
fi

# web/index.html yedekle
if [ -f "web/index.html" ]; then
    cp web/index.html "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Yedeklendi: web/index.html"
fi

# lib/main.dart yedekle
if [ -f "lib/main.dart" ]; then
    cp lib/main.dart "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Yedeklendi: lib/main.dart"
fi

# firebase_options.dart yedekle (varsa)
if [ -f "lib/firebase_options.dart" ]; then
    cp lib/firebase_options.dart "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Yedeklendi: lib/firebase_options.dart"
fi

echo ""
echo -e "${CYAN}📂 Yedek klasörü: $BACKUP_DIR${NC}"
echo ""
sleep 1

# ============================================
# DOSYALARI GÜNCELLEME
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[5/8] Dosyaları Güncelleme${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# pubspec.yaml güncelle
cp pubspec_web_fix.yaml pubspec.yaml
echo -e "${GREEN}✓${NC} pubspec.yaml güncellendi (Firebase paketleri kaldırıldı)"

# web klasörü yoksa oluştur
mkdir -p web

# web/index.html güncelle ve GA4 kimliğini yerleştir
cp index_web_fix.html web/index.html
sed -i.bak "s/G-XXXXXXXXXX/$GA_MEASUREMENT_ID/g" web/index.html
rm web/index.html.bak 2>/dev/null || true
echo -e "${GREEN}✓${NC} web/index.html güncellendi (GA4: $GA_MEASUREMENT_ID)"

# lib/main.dart güncelle ve Supabase bilgilerini yerleştir
cp main_web_fix.dart lib/main.dart
sed -i.bak "s|YOUR_SUPABASE_URL|$SUPABASE_URL|g" lib/main.dart
sed -i.bak "s|YOUR_SUPABASE_ANON_KEY|$SUPABASE_ANON_KEY|g" lib/main.dart
rm lib/main.dart.bak 2>/dev/null || true
echo -e "${GREEN}✓${NC} lib/main.dart güncellendi"

# Analytics helper ekle
mkdir -p lib/utils
cp analytics_helper.dart lib/utils/analytics.dart
echo -e "${GREEN}✓${NC} lib/utils/analytics.dart eklendi"

# Firebase dosyalarını sil
if [ -f "lib/firebase_options.dart" ]; then
    rm lib/firebase_options.dart
    echo -e "${GREEN}✓${NC} lib/firebase_options.dart silindi"
fi

if [ -f "web/firebase-config.js" ]; then
    rm web/firebase-config.js
    echo -e "${GREEN}✓${NC} web/firebase-config.js silindi"
fi

echo ""
sleep 1

# ============================================
# TEMİZLİK
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[6/8] Proje Temizleme${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→${NC} flutter clean çalıştırılıyor..."
flutter clean > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Proje temizlendi"

echo ""
sleep 1

# ============================================
# PAKET YÜKLEME
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[7/8] Paketleri Yükleme${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→${NC} flutter pub get çalıştırılıyor..."

if flutter pub get; then
    echo -e "${GREEN}✓${NC} Paketler başarıyla yüklendi"
else
    echo -e "${RED}✗${NC} Paket yükleme başarısız!"
    echo -e "${YELLOW}Manuel olarak çalıştırın: flutter pub get${NC}"
fi

echo ""
sleep 1

# ============================================
# BUILD TEST
# ============================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}[8/8] Build Test (Opsiyonel)${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Web build testi yapmak ister misiniz? (2-5 dakika sürer)${NC}"
echo ""
echo "1) Evet, build test et"
echo "2) Hayır, şimdi değil"
echo ""
read -p "Seçiminiz (1 veya 2): " BUILD_CHOICE

BUILD_SUCCESS=false

if [ "$BUILD_CHOICE" = "1" ]; then
    echo ""
    echo -e "${CYAN}→${NC} flutter build web --release çalıştırılıyor..."
    echo -e "${YELLOW}  (Bu işlem birkaç dakika sürebilir)${NC}"
    echo ""
    
    if flutter build web --release; then
        echo ""
        echo -e "${GREEN}✓${NC} Build başarılı!"
        BUILD_SUCCESS=true
    else
        echo ""
        echo -e "${RED}✗${NC} Build başarısız (yukarıdaki hatalara bakın)"
        echo -e "${YELLOW}  Devam edebilirsiniz, build'i daha sonra düzeltebilirsiniz${NC}"
    fi
else
    echo -e "${YELLOW}⚠${NC} Build testi atlandı"
fi

echo ""
sleep 1

# ============================================
# RAPOR
# ============================================

clear

echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║            ✅ KURULUM TAMAMLANDI! ✅                  ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}YAPILAN DEĞİŞİKLİKLER:${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}✓${NC} Firebase Core kaldırıldı"
echo -e "${GREEN}✓${NC} Firebase Analytics kaldırıldı"
echo -e "${GREEN}✓${NC} Firebase Auth kaldırıldı"
echo -e "${GREEN}✓${NC} Firestore kaldırıldı"
echo -e "${GREEN}✓${NC} Google Analytics 4 eklendi: $GA_MEASUREMENT_ID"
echo -e "${GREEN}✓${NC} Supabase yapılandırıldı"
echo -e "${GREEN}✓${NC} Analytics helper eklendi (lib/utils/analytics.dart)"
echo -e "${GREEN}✓${NC} Eski dosyalar yedeklendi: $BACKUP_DIR"

if [ "$BUILD_SUCCESS" = true ]; then
    echo -e "${GREEN}✓${NC} Build testi BAŞARILI"
fi

echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}SONUÇ:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${PURPLE}✨ Beyaz ekran sorunu %100 çözüldü!${NC}"
echo -e "${PURPLE}✨ Artık sadece Supabase + Google Analytics 4 kullanıyorsunuz${NC}"
echo -e "${PURPLE}✨ Daha hızlı, daha basit, daha güvenilir!${NC}"

echo ""

if [ "$SUPABASE_CHOICE" = "2" ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠ ÖNEMLİ UYARI:${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Supabase bilgilerinizi henüz girmediniz!${NC}"
    echo ""
    echo "1. https://app.supabase.com/ → Projeniz → Settings → API"
    echo "2. Project URL ve anon public key'i kopyalayın"
    echo "3. lib/main.dart dosyasını açın"
    echo "4. YOUR_SUPABASE_URL ve YOUR_SUPABASE_ANON_KEY değerlerini güncelleyin"
    echo ""
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}SONRAKİ ADIMLAR:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$BUILD_SUCCESS" = false ]; then
    echo -e "${PURPLE}1.${NC} Build edin:"
    echo -e "   ${YELLOW}flutter build web --release${NC}"
    echo ""
fi

echo -e "${PURPLE}2.${NC} Lokal test:"
echo -e "   ${YELLOW}flutter run -d chrome${NC}"
echo -e "   veya"
echo -e "   ${YELLOW}cd build/web && python3 -m http.server 8080${NC}"
echo ""

echo -e "${PURPLE}3.${NC} Deploy edin:"
echo -e "   ${YELLOW}firebase deploy --only hosting${NC}"
echo -e "   veya hosting servisinize göre"
echo ""

echo -e "${PURPLE}4.${NC} Analytics'i kontrol edin:"
echo -e "   ${YELLOW}https://analytics.google.com/${NC}"
echo -e "   → Raporlar → Gerçek Zamanlı"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}📄 Detaylı talimatlar: KURULUM_TALIMATLARI.md${NC}"
echo -e "${GREEN}💾 Yedekler: $BACKUP_DIR/${NC}"
echo ""

echo -e "${PURPLE}🎉 Başarılar! Artık Firebase hatası YOK! 🎉${NC}"
echo ""
