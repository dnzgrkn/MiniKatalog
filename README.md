# 📱 Mini Katalog Uygulaması

Flutter eğitimi kapsamında geliştirilen, modern ve kullanıcı dostu arayüze sahip bir **E-Ticaret Katalog Uygulaması**. Bu proje; temiz kod yapısı, nesne yönelimli programlama (OOP) prensipleri ve Flutter'ın temel widget mimarisi kullanılarak inşa edilmiştir.

---

## 🚀 Proje Hakkında
Bu uygulama, bir mağazanın ürünlerini kategorize ederek sergilemesine, detaylı inceleme yapılmasına ve sanal bir sepet yönetiminin simüle edilmesine olanak tanır.

### ✨ Temel Özellikler
* **Dinamik Ürün Listeleme:** `GridView` kullanılarak hazırlanan profesyonel ürün kartları.
* **Kategori Filtreleme:** `ChoiceChip` widget'ları ile kategorilere göre anlık filtreleme.
* **Gelişmiş Arama:** Ürün adı üzerinden gerçek zamanlı arama fonksiyonu.
* **Ürün Detay Sayfası:** Ürün özelliklerini, puanlamayı ve stok durumunu içeren detaylı görünüm.
* **Stok Yönetimi:** Stokta olmayan ürünler için görsel maskeleme ve "Sepete Ekle" kısıtlaması.
* **Navigasyon ve Veri Aktarımı:** Sayfalar arası nesne aktarımı ve sepet verisi geri bildirimi.

---

## 🛠 Teknik Detaylar
* **Dil:** Dart
* **Framework:** Flutter (v3.32.7)
* **Veri Yönetimi:** Local JSON (`assets/data/products.json`)
* **Mimari:** Clean UI & Model-View Separation

### 📂 Klasör Yapısı
```
lib/
├── models/     # Veri modelleri (Product)
├── screens/    # Ana sayfalar (Home, Detail)
├── widgets/    # Tekrar kullanılabilir bileşenler (ProductCard)
└── main.dart   # Uygulama giriş noktası
```

---

## 📦 Kurulum ve Çalıştırma

Projenin yerel makinenizde çalıştırılması için aşağıdaki adımları izleyin:

1.  **Depoyu Klonlayın:**
    ```bash
    git clone https://github.com/dnzgrkn/MiniKatalog.git
    ```
2.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```
3.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

---


## 🎓 Eğitim Çıktısı
Bu proje, Bilgisayar Mühendisliği eğitimi kapsamında;
- Proje klasörleme mantığı,
- Asset yönetimi (JSON/Görsel),
- State güncelleme süreçleri,
- Route Arguments kullanımı konularında yetkinlik kazanmak amacıyla hazırlanmıştır.

---

**Geliştirici**: Deniz Gürkan(https://github.com/dnzgrkn)
