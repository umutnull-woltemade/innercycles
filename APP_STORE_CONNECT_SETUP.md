# 🍎 App Store Connect'te Uygulama Oluşturma Rehberi

## 📋 ÖN HAZIRLIK

Başlamadan önce bunları hazırlayın:

### ✅ Gerekli Bilgiler:

1. **Bundle ID** 
   - Formatı: `com.sirketiniz.uygulamaadi`
   - Örnek: `com.mycompany.myapp`
   - ⚠️ Bu iOS projenizle AYNI olmalı!
   - Nereden bulunur: Xcode → Runner → General → Bundle Identifier

2. **Uygulama Adı**
   - Maksimum 30 karakter
   - App Store'da görünecek isim
   - ⚠️ Benzersiz olmalı (başkası kullanmıyorsa)

3. **Birincil Dil**
   - Türkçe veya İngilizce (sonra başka diller ekleyebilirsiniz)

4. **Apple Developer Hesabı**
   - Aktif Apple Developer Program üyeliği ($99/yıl)
   - https://developer.apple.com

---

## 🎯 ADIM 1: BUNDLE ID OLUŞTURMA (İlk kez yapılıyor)

### Apple Developer Portal'da:

1. **https://developer.apple.com/account** adresine gidin
2. Sol menüden **"Identifiers"** seçin
3. **"+"** butonuna tıklayın
4. **"App IDs"** seçin → Continue
5. **"App"** seçin → Continue

### Bundle ID Kaydetme:

1. **Description:** Uygulamanızın açıklaması (örn: "My Amazing App")
2. **Bundle ID:** 
   - **Explicit** seçin
   - Bundle ID girin: `com.sirketiniz.uygulamaadi`
3. **Capabilities** (Gerekli olanları seçin):
   - ☑️ **Sign in with Apple** (Apple ile giriş varsa)
   - ☑️ **Push Notifications** (bildirim varsa)
   - ☑️ **In-App Purchase** (uygulama içi satın alma varsa)
   - ☑️ **Associated Domains** (deep link varsa)
4. **Continue** → **Register**

✅ Bundle ID oluşturuldu!

---

## 🚀 ADIM 2: APP STORE CONNECT'TE UYGULAMA OLUŞTURMA

### 1. App Store Connect'e Giriş:

https://appstoreconnect.apple.com

### 2. Yeni Uygulama Oluşturma:

1. **"My Apps"** tıklayın
2. Sol üstteki **"+"** butonuna tıklayın
3. **"New App"** seçin

### 3. Uygulama Bilgilerini Doldurun:

#### **Platforms:**
- ☑️ **iOS** seçin

#### **Name:**
- Uygulamanızın adı (maksimum 30 karakter)
- Örnek: "My Amazing App"
- ⚠️ Bu isim App Store'da görünür
- ⚠️ Benzersiz olmalı (başkası kullanmıyorsa)

#### **Primary Language:**
- **Turkish** (Türkçe) veya **English (U.S.)**
- Sonra başka diller ekleyebilirsiniz

#### **Bundle ID:**
- Az önce oluşturduğunuz Bundle ID'yi seçin
- Dropdown'dan: `com.sirketiniz.uygulamaadi`
- ⚠️ Sonradan değiştirilemez!

#### **SKU:**
- Benzersiz bir ID (sadece sizin için)
- Örnek: `myapp001` veya `com.mycompany.myapp.v1`
- App Store'da görünmez
- İsterseniz Bundle ID ile aynı olabilir

#### **User Access:**
- **Full Access** (varsayılan - önerilir)
- Veya belirli kullanıcılara sınırlı erişim

### 4. Create Tıklayın

✅ Uygulamanız oluşturuldu!

---

## 📝 ADIM 3: UYGULAMA BİLGİLERİNİ TAMAMLAMA

Uygulama oluşturulduktan sonra şunları doldurmanız gerekir:

### A. App Information

Sol menüden **"App Information"** seçin:

#### **Name:**
- Uygulama adı (App Store'da görünür)

#### **Subtitle:** (İsteğe bağlı)
- Alt başlık (maksimum 30 karakter)
- Örnek: "Hayatınızı Kolaylaştırın"

#### **Category:**
- **Primary Category:** Ana kategori seçin
  - Örnek: Productivity, Games, Education, vb.
- **Secondary Category:** (İsteğe bağlı) İkinci kategori

#### **Content Rights:**
- Telif hakkı bilgisi veya üçüncü parti içerik var mı?
- Genelde **No** seçilir

#### **Age Rating:** (Sonra doldurulacak)
- Edit → Anketi doldurun
- İçeriğe göre yaş sınırlaması belirler

#### **Privacy Policy URL:**
- ⚠️ **ZORUNLU!**
- Gizlilik politikanızın URL'si
- Örnek: `https://yourwebsite.com/privacy`
- Yoksa oluşturmanız gerekir

#### **Pricing and Availability** (Sol menü):

1. **Price:**
   - **Free** (Ücretsiz)
   - Veya fiyat seçin ($0.99, $1.99, vb.)

2. **Availability:**
   - Hangi ülkelerde yayınlanacak?
   - Tüm ülkeler veya seçili ülkeler

3. **Pre-Order:** (İsteğe bağlı)
   - Ön sipariş açmak isterseniz

---

### B. App Privacy (Gizlilik Bilgileri)

⚠️ **ZORUNLU - Apple'ın gereksinimi**

Sol menüden **"App Privacy"** seçin:

#### 1. Get Started tıklayın

#### 2. Veri Toplama Anketi:

**"Does your app collect data from end users?"**

- Veri topluyorsanız: **Yes**
- Hiç veri toplamıyorsanız: **No**

#### 3. Toplanan Verileri Seçin (Yes dediyseniz):

Yaygın kategoriler:

- **Contact Info:**
  - Name, Email, Phone Number, vb.
  
- **User Content:**
  - Photos, Videos, Audio, vb.
  
- **Identifiers:**
  - User ID, Device ID, Advertising ID
  
- **Usage Data:**
  - Product Interaction, Advertising Data, Analytics
  
- **Diagnostics:**
  - Crash Data, Performance Data

#### 4. Her veri türü için:

- **Data Type:** Veri türü seçin
- **Usage:** Nasıl kullanılıyor?
  - Analytics, App Functionality, Advertising, vb.
- **Linked to User:** Kullanıcıyla ilişkilendiriliyor mu?
  - Yes / No
- **Tracking:** Tracking için mi kullanılıyor?
  - Yes / No

#### Örnek: AdMob kullanıyorsanız

- **Identifiers → Advertising Identifier**
  - Usage: Advertising
  - Linked to User: No
  - Tracking: Yes

- **Usage Data → Product Interaction**
  - Usage: Analytics, Advertising
  - Linked to User: No
  - Tracking: No

#### 5. Privacy Policy URL tekrar doğrulayın

#### 6. Publish tıklayın

✅ Gizlilik bilgileri tamamlandı!

---

### C. 1.0 Prepare for Submission

Sol menüden **"1.0 Prepare for Submission"** seçin (veya iOS App):

#### **Screenshots ve Previews:**

⚠️ **ZORUNLU - En az bir cihaz seti gerekli**

Her cihaz boyutu için ekran görüntüleri:

1. **iPhone 6.7" Display** (iPhone 14 Pro Max, 15 Pro Max, vb.)
   - En az 3, en fazla 10 screenshot
   - Boyut: 1290 x 2796 pixels veya 2796 x 1290
   - Format: PNG veya JPG

2. **iPhone 6.5" Display** (iPhone 11 Pro Max, XS Max, vb.)
   - Aynı gereksinimler
   - Boyut: 1242 x 2688 pixels

3. **iPhone 5.5" Display** (eski cihazlar)
   - İsteğe bağlı ama önerilir
   - Boyut: 1242 x 2208 pixels

💡 **İpucu:** En büyük boyuttan (6.7") screenshot alın, Apple küçük boyutlar için ölçeklendirir.

**Screenshot Nasıl Alınır?**

Simulator'da:
1. Xcode → Open Developer Tool → Simulator
2. iPhone 15 Pro Max seçin
3. ⌘S (Command + S) ile screenshot alın
4. Desktop'ta bulun

#### **Promotional Text:** (İsteğe bağlı)
- Güncelleme duyuruları için (170 karakter)
- Uygulama güncellemeden değiştirilebilir

#### **Description:**
- ⚠️ **ZORUNLU**
- Uygulama açıklaması (maksimum 4000 karakter)
- App Store'da "About" kısmında görünür
- Özellikler, faydalar, nasıl kullanılır, vb.

Örnek yapı:
```
[Kısa Tanıtım]

✨ ÖZELLİKLER:
• Özellik 1
• Özellik 2
• Özellik 3

🎯 FAYDALAR:
• Fayda 1
• Fayda 2

💡 NASIL KULLANILIR:
1. Adım 1
2. Adım 2
3. Adım 3
```

#### **Keywords:**
- Arama için anahtar kelimeler
- Maksimum 100 karakter
- Virgülle ayırın (boşluk kullanmayın)
- Örnek: `productivity,task,manager,organize,todo,list`

#### **Support URL:**
- ⚠️ **ZORUNLU**
- Destek sayfanız
- Örnek: `https://yourwebsite.com/support`

#### **Marketing URL:** (İsteğe bağlı)
- Pazarlama web siteniz
- Örnek: `https://yourwebsite.com`

#### **Version:**
- İlk yayın için: **1.0.0** veya **1.0**

#### **Copyright:**
- Telif hakkı bilgisi
- Örnek: `2025 Your Company Name`

#### **Build:**

⚠️ Henüz build yüklenmedi!

1. Önce Xcode'da **Archive** yapmanız gerekir
2. **Upload to App Store** yapmanız gerekir
3. Build işlendikten sonra (10-60 dakika) buradan seçebilirsiniz

Şimdilik **boş bırakın**. Archive/Upload sonrası seçeceksiniz.

#### **App Clip:** (İsteğe bağlı)
- App Clip varsa yapılandırın
- Genelde No / Skip

#### **Routing App Coverage File:** (İsteğe bağlı)
- Navigasyon uygulamaları için
- Genelde No

---

### D. App Review Information

Uygulama incelemecileri için bilgiler:

#### **Contact Information:**
- **First Name:** Adınız
- **Last Name:** Soyadınız
- **Phone Number:** Telefon numaranız (+90...)
- **Email:** E-posta adresiniz

#### **Demo Account:** (Giriş gerekliyse)

Uygulamanız giriş gerektiriyorsa:
- **Username:** Test kullanıcı adı
- **Password:** Test şifresi
- ⚠️ İncelemeciler bu hesapla giriş yapacak!

#### **Notes:** (İsteğe bağlı)

İncelemecilere özel notlar:
- Nasıl test edilir
- Hangi özelliklere dikkat etmeli
- Özel yapılandırma gereklilikleri

Örnek:
```
Test için demo hesap kullanabilirsiniz.
Ana özellik "+" butonuna basarak yeni kayıt oluşturmaktır.
Bildirim testi için "Settings" bölümünü kullanın.
```

#### **Attachment:** (İsteğe bağlı)
- Ekran görüntüsü veya video ekleyebilirsiniz
- Karmaşık özellikler için yardımcı olur

---

### E. Age Rating (Yaş Sınıflandırması)

**App Information** → **Age Rating** → **Edit**

Anketi doldurun:

#### Örnek Sorular:

1. **Unrestricted Web Access?**
   - Web tarayıcısı varsa: Yes
   - Yoksa: No

2. **Simulated Gambling?**
   - Kumar içeriği var mı: No (genelde)

3. **Realistic Violence?**
   - Şiddet içeriği: None / Infrequent / Frequent

4. **Profanity or Crude Humor?**
   - Küfür/kaba mizah: None / Infrequent / Frequent

5. **Sexual Content or Nudity?**
   - Cinsel içerik: None / Infrequent / Frequent

6. **Alcohol, Tobacco, or Drug Use?**
   - Alkol/uyuşturucu: None / Infrequent / Frequent

Cevaplarınıza göre yaş sınırı belirlenir: **4+, 9+, 12+, 17+**

---

## ✅ ADIM 4: KAYDET VE BEKLEYİN

### Henüz Göndermeyin!

Tüm bilgileri doldurduktan sonra:

1. **Save** tıklayın (sağ üstte)
2. Build hazır değil, bu normal
3. Şimdi **Xcode'da Archive & Upload** yapmanız gerekir

---

## 📦 ADIM 5: BUILD YÜKLEME (Xcode'dan)

### Xcode'da Archive yaptıktan sonra:

1. **Organizer** → **Distribute App**
2. **App Store Connect** → Upload
3. 5-10 dakika bekleyin

### App Store Connect'te:

1. Build yüklendi, "Processing" gösterir
2. 10-60 dakika bekleyin
3. E-posta gelecek: "Build processed successfully"

### Build Seçimi:

1. **1.0 Prepare for Submission** → **Build** bölümüne dön
2. **+ icon** tıklayın
3. Yüklediğiniz build'i seçin
4. **Done** tıklayın

✅ Build eklendi!

---

## 🎯 ADIM 6: EXPORT COMPLIANCE

Build seçtikten sonra sorulur:

**"Is your app designed to use cryptography or does it contain or incorporate cryptography?"**

### Çoğu Flutter App için:

- **Yes** seçin (HTTPS kullanıyorsanız)
- Sonraki soru: **"Does your app qualify for any of the exemptions provided in Category 5, Part 2?"**
  - **Yes** seçin
- Apple'ın HTTPS şifrelemesi kullanıyorsanız: Exempt

### Özel şifreleme kullanıyorsanız:

- Apple ile iletişime geçin
- Export compliance belgeleri gerekebilir

Çoğu durumda: **Exempt (Yes, Yes)**

---

## 🚀 ADIM 7: İNCELEMEYE GÖNDER

Tüm alanlar dolduysa:

### Kontrol Listesi:

- ✅ Screenshots yüklendi
- ✅ Description yazıldı
- ✅ Keywords eklendi
- ✅ Support URL eklendi
- ✅ Privacy Policy URL eklendi
- ✅ Build seçildi
- ✅ Export Compliance tamamlandı
- ✅ Age Rating tamamlandı
- ✅ App Review Information dolduruldu

### Gönder:

1. **"Add for Review"** veya **"Submit for Review"** tıklayın
2. Onay penceresi gelir
3. **Submit** tıklayın

✅ İncelemeye gönderildi!

---

## ⏱️ İNCELEME SÜRECİ

### Durumlar:

1. **Waiting for Review** → Sırada bekliyor (24-48 saat)
2. **In Review** → İnceleniyor (birkaç saat)
3. **Pending Developer Release** → Onaylandı! ✅
   - Siz yayınlama düğmesine basmalısınız
4. **Ready for Sale** → Yayında! 🎉
5. **Rejected** ❌ → Reddedildi
   - Sebepleri okuyun
   - Düzeltin
   - Tekrar gönderin

### İnceleme Süresi:

- **İlk gönderim:** 24-48 saat
- **Tekrar gönderim:** 12-24 saat
- **Acil durum:** Expedited Review talep edebilirsiniz (sınırlı)

---

## 📱 ADIM 8: YAYINLAMA

### Onaylandıktan Sonra:

#### **Otomatik Yayın:**

**"Version Release"** ayarlarından:
- **Automatically release this version** → Onaylanır onaylanmaz yayınlanır

#### **Manuel Yayın:** (Önerilir)

- **Manually release this version** → Siz düğmeye basana kadar bekler

Manuel seçtiyseniz:
1. App Store Connect → My Apps → Uygulamanız
2. **Release this Version** düğmesine basın
3. Birkaç saat içinde App Store'da!

---

## 🎉 TEBRIKLER!

Uygulamanız App Store'da yayında!

---

## 🔄 GÜNCELLEME YAYINLAMA

Sonraki versiyonlar için:

### 1. Yeni Versiyon Oluştur:

1. App Store Connect → My Apps → Uygulamanız
2. Sol tarafta **"+"** → **Add Version**
3. Versiyon numarası girin (örn: 1.0.1, 1.1.0, 2.0.0)

### 2. "What's New" Yazın:

Değişiklik notları (maksimum 4000 karakter):

```
Version 1.1.0

✨ Yenilikler:
• Yeni özellik 1
• Yeni özellik 2

🐛 Düzeltmeler:
• Bug düzeltmesi 1
• Bug düzeltmesi 2

⚡ İyileştirmeler:
• Performans iyileştirmeleri
```

### 3. Build Yükle & Seç:

- Xcode'da Archive → Upload
- Build işlenince seç

### 4. Gönder:

- Submit for Review

---

## 💡 ÖNEMLİ İPUÇLARI

### Screenshots:

1. **Kaliteli olsun:** 
   - Uygulamanızın en iyi özelliklerini gösterin
   - İlk 1-2 screenshot en önemli (kullanıcılar önce bunları görür)

2. **Metin ekleyin:**
   - Screenshot'lara özellik açıklamaları ekleyin
   - Canva, Figma gibi araçlar kullanabilirsiniz

3. **Gerçek içerik kullanın:**
   - Placeholder/test içerik yerine gerçek veri gösterin

### Description:

1. **İlk 2-3 cümle önemli:**
   - Kullanıcılar sadece ilk satırları görür ("more" basmazsa)
   - Ana değer önerisini ilk satıra koyun

2. **Emoji kullanın:**
   - Görsel çekicilik için
   - Ama aşırıya kaçmayın

3. **Anahtar kelime optimizasyonu:**
   - Description'da da önemli kelimeleri kullanın
   - Ama doğal yazmaya özen gösterin

### Keywords:

1. **Boşluk kullanmayın:**
   - Doğru: `todo,task,productivity`
   - Yanlış: `todo, task, productivity` (boşluk karakter israfı)

2. **App adını tekrar yazmayın:**
   - Zaten otomatik indexleniyor

3. **Rakip uygulamaların ismini yazmayın:**
   - Apple yasak ediyor

4. **Plurals gereksiz:**
   - "task" yeterli, "tasks" yazmaya gerek yok
   - Apple otomatik çoğul halleri de indexler

### Review:

1. **Demo hesap verin:**
   - Giriş gerekliyse mutlaka çalışan bir hesap verin
   - İncelemeciler test edemezse reddeder

2. **Açık olun:**
   - Karmaşık özellikler varsa Notes'ta açıklayın
   - Video gösterim ekleyebilirsiniz

3. **Test edin:**
   - Göndermeden önce kendiniz test edin
   - Crash olmadığından emin olun

---

## 📞 YARDIM

### App Store Connect Destek:

- https://developer.apple.com/support/app-store-connect/

### App Store Review Guidelines:

- https://developer.apple.com/app-store/review/guidelines/

### İnceleme Durumu:

- App Store Connect → Resolution Center

---

## ✅ ÖZET CHECKLIST

App Store'a göndermeden önce:

- ✅ Bundle ID oluşturuldu (developer.apple.com)
- ✅ App Store Connect'te app oluşturuldu
- ✅ Tüm bilgiler dolduruldu:
  - ✅ App Information (Privacy URL, Category, vb.)
  - ✅ Pricing & Availability
  - ✅ App Privacy
  - ✅ Screenshots (en az 1 cihaz seti)
  - ✅ Description
  - ✅ Keywords
  - ✅ Support URL
  - ✅ Build seçildi
  - ✅ Export Compliance
  - ✅ App Review Information
  - ✅ Age Rating
- ✅ Xcode'da Archive & Upload yapıldı
- ✅ Build işlendi (e-posta geldi)
- ✅ Tüm sarı uyarılar giderildi

---

## 🚀 BAŞARILAR!

Artık App Store Connect'te uygulamanızı oluşturmaya hazırsınız!

Sorularınız için buradayım! 💪
