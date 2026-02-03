# 🇹🇷 iOS App Store Yayınlama Rehberi

## 🚀 HIZLI BAŞLANGIÇ

### Adım 1: Script'i Çalıştır

Terminal'de proje klasörünüzde:

```bash
chmod +x auto_deploy.sh
./auto_deploy.sh
```

**⏱️ Süre:** 10-15 dakika

---

## 📋 SCRIPT ÖNCESİ KONTROL LİSTESİ

### ✅ Hazırlayın:

1. **Firebase GoogleService-Info.plist**
   - https://console.firebase.google.com
   - Projenizi seçin → iOS app ekleyin
   - GoogleService-Info.plist'i indirin
   - `~/Downloads/` klasörüne kaydedin

2. **AdMob App ID** (İsteğe bağlı)
   - https://apps.admob.com
   - Formatı: `ca-app-pub-XXXXXXXXXXXXX~XXXXXXXXXX`
   - Yoksa test ID kullanılır (sonra değiştirin)

3. **Apple Developer Hesabı**
   - https://developer.apple.com
   - Developer Program üyeliği aktif olmalı

4. **App Store Connect'te Uygulama**
   - https://appstoreconnect.apple.com
   - My Apps → + → New App
   - Bundle ID ve uygulama bilgilerini girin

---

## 🔧 SCRIPT SONRASI: XCODE YAPILANDIRMA

### 1. Xcode'u Açın

```bash
open ios/Runner.xcworkspace
```

**⚠️ ÖNEMLİ:** `.xcworkspace` açın, `.xcodeproj` DEĞİL!

### 2. Target Seçimi

- Sol panelde **Runner** (mavi ikon) tıklayın
- TARGETS altında **Runner** seçin

### 3. General Sekmesi

Şunları ayarlayın:
- **Display Name:** Uygulamanızın adı
- **Bundle Identifier:** `com.sirketiniz.uygulamaniz`
  - ⚠️ App Store Connect'teki ile AYNI olmalı
- **Version:** `1.0.0`
- **Build:** `1`
- **Deployment Target:** `iOS 13.0` veya üzeri

### 4. Signing & Capabilities Sekmesi

#### A. İmzalamayı Yapılandırın:
1. ☑️ **"Automatically manage signing"** işaretleyin
2. **Team:** Apple Developer ekibinizi seçin
   - Listede yok mu? → Xcode → Settings → Accounts → Apple ID ekleyin

#### B. Gerekli Capability'leri Ekleyin:
1. **+ Capability** butonuna tıklayın
2. Şunları ekleyin:
   - **Sign in with Apple** (Apple ile giriş)
   - **Push Notifications** (Bildirimler)
3. Her ikisinde de yeşil ✓ işareti olmalı

### 5. Build Settings Sekmesi

1. Arama kutusuna: `bitcode` yazın
2. **Enable Bitcode** → **NO** yapın (hem Debug hem Release için)

### 6. GoogleService-Info.plist Kontrolü

Eğer script eklemediyse:
1. Sol panelde **Runner** klasörüne sağ tıklayın
2. **Add Files to "Runner"** seçin
3. `GoogleService-Info.plist` dosyasını seçin
4. ☑️ **"Copy items if needed"** işaretleyin
5. ☑️ **Runner** target'ını seçin
6. **Add** tıklayın

---

## 📦 ARCHIVE (ARŞİVLEME)

### 1. Cihaz Seçimi

Xcode üst kısmında → **"Any iOS Device (arm64)"** seçin

**⚠️ Simulator OLMAZSA!**

### 2. Temizle ve Arşivle

1. **Product** → **Clean Build Folder** (⇧⌘K)
2. **Product** → **Archive**
3. Bekleyin... ☕ (5-15 dakika)

Build başarılı olursa **Organizer** penceresi açılır! ✅

### 3. Hata Alırsanız

**"No such module" hatası:**
```bash
cd ios
pod install
cd ..
```
Xcode'u kapatıp tekrar açın.

**"Code signing error":**
- Signing & Capabilities → Team seçilmiş mi kontrol edin
- Xcode → Settings → Accounts → Apple ID'niz var mı?

**"Archive button grileşik":**
- "Any iOS Device" seçili olmalı (simulator değil!)

---

## ☁️ APP STORE'A YÜKLEME

### 1. Organizer'da

Arşivleme bitince açılan pencerede:

1. **"Distribute App"** tıklayın
2. **"App Store Connect"** seçin → Next
3. **"Upload"** seçin → Next
4. ☑️ **"Upload your app's symbols"** işaretleyin
5. **Upload** tıklayın

⏱️ **Süre:** 3-10 dakika

### 2. İşleme Bekleyin

1. E-postanızı kontrol edin (Apple'dan onay gelir)
2. https://appstoreconnect.apple.com açın
3. **My Apps** → Uygulamanız → **TestFlight**
4. Build "Processing" gösterecek (10-60 dakika)
5. Hazır olunca TestFlight'ta test edin

---

## 🎯 TESTFLIGHT'TA TEST

### İç Test:

1. App Store Connect → TestFlight
2. **Internal Testing** → + butonuna tıklayın
3. Build seçin → İç test kullanıcılarını ekleyin
4. Test edin!

### Dış Test (İsteğe bağlı):

1. **External Testing** → + butonuna tıklayın
2. Build seçin
3. Beta App Review için gönderin
4. Onaylandıktan sonra harici kullanıcılara gönderin

---

## 🚀 APP STORE'DA YAYINLAMA

### 1. App Store Connect'te Hazırlık

1. https://appstoreconnect.apple.com
2. **My Apps** → Uygulamanız
3. **App Store** sekmesi

### 2. Bilgileri Doldurun

- **App Information:**
  - İsim, kategori, alt başlık
  - Privacy Policy URL
  - Support URL

- **Pricing and Availability:**
  - Fiyat (ücretsiz / ücretli)
  - Hangi ülkelerde yayınlanacak

- **App Privacy:**
  - Gizlilik anketi doldurun

- **1.0 Prepare for Submission:**
  - **Ekran görüntüleri** (her cihaz boyutu için)
  - **Açıklama** (4000 karakter max)
  - **Anahtar kelimeler**
  - **Promosyon metni**
  - **Support URL**
  - **Pazarlama URL** (isteğe bağlı)
  
- **Build:**
  - TestFlight'tan build seçin

- **Age Rating:**
  - Anketi doldurun

### 3. Gönder

1. Tüm sarı uyarılar giderilmeli
2. **"Add for Review"** veya **"Submit for Review"** tıklayın
3. Export Compliance sorusu:
   - Şifreleme kullanıyorsanız: Yes
   - Sadece HTTPS kullanıyorsanız: Genelde No (Apple'ın şifrelemesi)

---

## ⏱️ İNCELEME SÜRECİ

- **İlk İnceleme:** 24-48 saat
- **Tekrar İnceleme:** 12-24 saat
- **Durum takibi:** App Store Connect'ten

### Olası Durumlar:

- **Waiting for Review:** Sırada bekliyor
- **In Review:** İnceleniyor
- **Pending Developer Release:** Onaylandı, yayınlama izninizi bekliyor
- **Ready for Sale:** Yayında! 🎉
- **Rejected:** Reddedildi (sebepleri okuyun, düzeltin, tekrar gönderin)

---

## 🔄 GÜNCELLEME YAYINLAMA

Sonraki versiyonlar için:

### 1. Versiyon Numaralarını Artırın

`ios/Runner/Info.plist`:
```xml
<key>CFBundleShortVersionString</key>
<string>1.0.1</string>  <!-- Önceden 1.0.0 -->

<key>CFBundleVersion</key>
<string>2</string>  <!-- Önceden 1 -->
```

### 2. Kod Değişikliklerini Yapın

Flutter kodunuzda değişiklikler yapın.

### 3. Build & Upload

```bash
# Temizle
flutter clean
cd ios && pod install && cd ..

# Build
flutter build ios --release --no-codesign

# Xcode'da Archive & Upload
open ios/Runner.xcworkspace
```

### 4. App Store Connect

1. Yeni versiyon oluşturun (+ Version or Platform)
2. Değişiklikleri yazın ("What's New")
3. Yeni build seçin
4. Submit for Review

---

## 📱 ÖNEMLİ KONTROLLER

### Her Upload Öncesi:

- ✅ GoogleService-Info.plist ekli
- ✅ AdMob App ID gerçek ID (test ID değil!)
- ✅ Bundle ID doğru
- ✅ Version ve Build numarası artmış
- ✅ Enable Bitcode = NO
- ✅ Sign in with Apple capability'si var
- ✅ Push Notifications capability'si var
- ✅ Team seçili

### Test Checklist:

- ✅ Uygulama açılıyor
- ✅ Ana özellikler çalışıyor
- ✅ Reklamlar görünüyor (test modunda)
- ✅ Bildirimler çalışıyor
- ✅ Apple ile giriş çalışıyor
- ✅ Crash olmuyor

---

## 🆘 YARDIM VE KAYNAKLAR

### Script Çıktıları:

Script çalıştırdıktan sonra şunları okuyun:
- **DEPLOYMENT_REPORT.txt** - Detaylı rapor
- **COMPLETE_DEPLOYMENT_SIMPLE.md** - Basit adımlar
- Terminal çıktısı - Hatalar ve uyarılar

### Apple Kaynaklar:

- **App Store Connect:** https://appstoreconnect.apple.com
- **Developer Portal:** https://developer.apple.com
- **App Store Review Guidelines:** https://developer.apple.com/app-store/review/guidelines/

### Firebase & AdMob:

- **Firebase Console:** https://console.firebase.google.com
- **AdMob Console:** https://apps.admob.com

---

## 💡 İPUÇLARI

1. **Her zaman TestFlight'ta test edin** - App Store'a göndermeden önce
2. **Screenshot'ları özenle hazırlayın** - App Store'da iyi görünüm önemli
3. **Build numarasını her upload'ta artırın** - Aksi halde hata alırsınız
4. **Privacy Policy hazırlayın** - Zorunlu!
5. **İnceleme notları yazın** - İncelemeyi hızlandırır
6. **İlk red'de yılmayın** - Normal, düzeltin ve tekrar gönderin

---

## ✅ BAŞARI!

Artık hazırsınız! Script'i çalıştırın:

```bash
chmod +x auto_deploy.sh
./auto_deploy.sh
```

Sonra bu rehberdeki adımları izleyin.

**Başarılar! 🚀**

---

## 📞 Sorularınız mı var?

- Script hataları için: Terminal çıktısını paylaşın
- Xcode hataları için: Tam hata mesajını paylaşın
- Build sorunları için: TROUBLESHOOTING.md dosyasına bakın

**Kolay gelsin!** 💪
