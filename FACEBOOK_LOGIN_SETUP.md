# Facebook Login Setup Guide

Bu loyihaga Facebook Login funksiyasini qo'shish uchun quyidagi qadamlarni bajaring:

## 1. Facebook Developer Console'da App yarating

1. [Facebook Developers](https://developers.facebook.com/) ga kiring
2. "My Apps" > "Create App" tanlang
3. App turini tanlang (Consumer yoki Business)
4. App nomi va email manzilini kiriting
5. App ID va App Secret ni oling

## 2. Facebook Login Product'ini qo'shing

1. App dashboard'da "Add Product" bosing
2. "Facebook Login" ni tanlang
3. Platform sifatida "Android" va "iOS" ni qo'shing

## 3. Android uchun konfiguratsiya

### 3.1 Package Name va Class Name
- Package Name: `com.example.vela` (yoki sizning package name'ingiz)
- Class Name: `com.example.vela.MainActivity`

### 3.2 Key Hashes
Key hash'ni olish uchun quyidagi komandani ishga tushiring:

```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

### 3.3 strings.xml faylini yangilang
`android/app/src/main/res/values/strings.xml` faylida:

```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
```

## 4. iOS uchun konfiguratsiya

### 4.1 Bundle ID
- Bundle ID: `com.example.vela` (yoki sizning bundle ID'ingiz)

### 4.2 Info.plist faylini yangilang
`ios/Runner/Info.plist` faylida:

```xml
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>Vela</string>
```

URL Scheme:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>fbYOUR_FACEBOOK_APP_ID</string>
</array>
```

## 5. Dependencies ni o'rnating

```bash
flutter pub get
```

## 6. Facebook App Settings

### 6.1 App Review
Facebook Login uchun app review kerak bo'lishi mumkin. Test uchun:
1. App Settings > Basic
2. "App Domains" ga test domain qo'shing
3. "Privacy Policy URL" ni to'ldiring

### 6.2 Test Users
Test uchun Facebook test user'lar yarating:
1. Roles > Test Users
2. "Add" bosing
3. Test user'lar yarating

## 7. Ilovani ishga tushiring

```bash
flutter run
```

## 8. Test qilish

1. Facebook Login tugmasini bosing
2. Facebook hisobingiz bilan tizimga kiring
3. User ma'lumotlari (email, ism, rasm) olinishini tekshiring

## Eslatmalar

- Facebook App ID va Client Token ni to'g'ri joylashtiring
- Test user'lar bilan test qiling
- Production'da app review o'tkazish kerak
- Privacy Policy va Terms of Service qo'shish tavsiya etiladi

## Xatoliklar va yechimlar

### "Invalid key hash" xatosi
- Key hash'ni to'g'ri olish va Facebook'ga kiritish kerak
- Debug va release key hash'lari farq qilishi mumkin

### "App not configured" xatosi
- Facebook App ID va Client Token to'g'ri kiritilganini tekshiring
- Platform settings to'g'ri sozlanganini tekshiring

### "Permission denied" xatosi
- Facebook Login permissions to'g'ri sozlanganini tekshiring
- User'ning Facebook hisobida email ko'rsatilganini tekshiring
