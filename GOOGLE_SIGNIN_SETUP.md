# Google Sign-In Setup Guide (Firebase-siz)

Bu loyihaga Google Sign-In funksiyasini qo'shish uchun quyidagi qadamlarni bajaring:

## 1. Google Cloud Console’da OAuth 2.0 Client ID yarating

1. [Google Cloud Console](https://console.cloud.google.com/) ga kiring
2. "APIs & Services" > "Credentials" bo‘limiga o‘ting
3. "Create Credentials" > "OAuth client ID" tanlang
4. Platformani tanlang (Android/iOS)
5. Paket nomi/bundle ID va SHA1 (Android) ni kiriting
6. Client ID va Client Secret ni oling

## 2. Android uchun konfiguratsiya

- `android/app/src/main/AndroidManifest.xml` faylida quyidagilarni tekshiring:
  ```xml
  <application ...>
    <meta-data android:name="com.google.android.gms.client_id"
      android:value="YOUR_CLIENT_ID.apps.googleusercontent.com" />
  </application>
  ```

## 3. iOS uchun konfiguratsiya

- `ios/Runner/Info.plist` faylida quyidagilarni qo‘shing:
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
      </array>
    </dict>
  </array>
  ```

## 4. Dependencies ni o‘rnating

```bash
flutter pub get
```

## 5. Ilovani ishga tushiring

```bash
flutter run
```

## Eslatma
- Endi Firebase kerak emas, faqat Google Sign-In ishlaydi.
- OAuth Client ID ni to‘g‘ri joylashtiring.
- Foydalanuvchi ma’lumotlari (ism, email) Google hisobidan olinadi. 