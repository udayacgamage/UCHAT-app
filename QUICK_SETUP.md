# 🚀 UCHAT - Quick Setup Guide

## ⚡ 5-MINUTE SETUP

### Step 1: Verify Prerequisites (2 min)
```bash
# Check Flutter
flutter --version
# Should show: Flutter 3.11.3+ and Dart 3.11.3+

# Check Android setup
flutter doctor --android
# Should show: Android SDK, Android Studio, JDK all ✓

# Check iOS setup (macOS only)
flutter doctor --ios
# Should show: Xcode, iOS toolchain all ✓
```

### Step 2: Clone & Setup (1 min)
```bash
# Clone repository
git clone <your-repo-url>
cd chatapp

# Get dependencies
flutter pub get
```

### Step 3: Firebase Configuration (1 min)
```bash
# Automatic setup (recommended)
flutterfire configure

# Follow the prompts to select your Firebase project
```

### Step 4: Run the App (1 min)
```bash
# Android
flutter run

# iOS (macOS only)
flutter run

# Web (Chrome)
flutter run -d chrome

# Release build
flutter build apk --release
```

---

## 📋 ONE-PAGE CHECKLIST

```
SYSTEM REQUIREMENTS
└─ [ ] Flutter 3.11.3+
├─ [ ] Dart 3.11.3+
├─ [ ] 4GB RAM minimum (8GB recommended)
├─ [ ] 10GB+ disk space
└─ [ ] Windows 10+, macOS 10.15+, or Ubuntu 18.04+

ANDROID SETUP (Required)
├─ [ ] Android SDK installed
├─ [ ] Min SDK 21 available
├─ [ ] JDK 17 installed
└─ [ ] Android emulator or device connected

iOS SETUP (macOS only)
├─ [ ] Xcode 14.0+ installed
├─ [ ] iOS 11.0+ simulator or device
└─ [ ] CocoaPods installed

FIREBASE SETUP (Required)
├─ [ ] Firebase account created
├─ [ ] Firestore database enabled
├─ [ ] Authentication enabled (Email + Google)
├─ [ ] google-services.json downloaded
└─ [ ] GoogleService-Info.plist downloaded

PROJECT SETUP
├─ [ ] Repository cloned
├─ [ ] `flutter pub get` executed
├─ [ ] Firebase files placed correctly
├─ [ ] No build errors
└─ [ ] App runs successfully
```

---

## 🔧 INSTALLATION PATHS

### Windows
```
C:\Android\sdk\              ← Android SDK
C:\Program Files\Java\       ← JDK 17
D:\flutter\                  ← Flutter SDK
```

### macOS
```
~/Library/Android/sdk/       ← Android SDK
/Applications/Xcode.app/     ← Xcode
~/development/flutter/       ← Flutter SDK
```

### Linux
```
~/Android/Sdk/               ← Android SDK
/usr/lib/jvm/java-17/        ← JDK 17
~/development/flutter/       ← Flutter SDK
```

---

## 📊 MINIMAL VERSIONS

| Tool | Minimum | Current |
|------|---------|---------|
| Flutter | 3.11.3 | 3.24.0+ |
| Dart | 3.11.3 | 3.24.0+ |
| Android SDK | 21 | 36 |
| JDK | 17 | 17+ |
| Xcode | 14.0 | 15.0+ |
| iOS | 11.0 | 17.0+ |

---

## 🚨 CRITICAL REQUIREMENTS

### For Android
1. ✅ Android SDK installed
2. ✅ Min SDK version 21 (Android 5.0)
3. ✅ JDK 17
4. ✅ Gradle compatible

### For iOS (macOS only)
1. ✅ Xcode 14.0+
2. ✅ iOS 11.0+ target
3. ✅ CocoaPods
4. ✅ Apple developer account (optional)

### For Firebase
1. ✅ Google account
2. ✅ Firebase project created
3. ✅ Credentials downloaded
4. ✅ Files in correct location

---

## 💾 STORAGE REQUIREMENTS

### Disk Space Breakdown
```
Flutter SDK          ~2GB
Android SDK         ~3GB
Xcode (macOS only)  ~12GB
Project Code        ~500MB
Dependencies        ~1GB
Total Minimum       ~10GB
Total Recommended   ~20GB
```

---

## 🔐 Firebase Files Required

### Android
**File**: `google-services.json`  
**Location**: `android/app/google-services.json`  
**Get From**: Firebase Console → Project Settings

### iOS
**File**: `GoogleService-Info.plist`  
**Location**: `ios/Runner/GoogleService-Info.plist`  
**Get From**: Firebase Console → Project Settings

---

## ⚡ FASTEST SETUP (Assuming pre-installed tools)

```bash
# Total time: ~5 minutes

# 1. Clone (1 min)
git clone <repo> && cd chatapp

# 2. Dependencies (1 min)
flutter pub get

# 3. Firebase (1 min)
flutterfire configure

# 4. Run (1 min)
flutter run

# 5. Done! (1 min)
# App should launch on emulator/device
```

---

## 🆘 TROUBLESHOOTING

### "Flutter not found"
```bash
# Add to PATH
export PATH="$PATH:$HOME/flutter/bin"

# Verify
flutter --version
```

### "Android SDK not found"
```bash
# Set environment variable
export ANDROID_HOME="$HOME/Library/Android/sdk"  # macOS
export ANDROID_HOME="$HOME/Android/Sdk"          # Linux
```

### "Gradle build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### "Firebase not configured"
```bash
# Run setup again
flutterfire configure --project=your-project-id
```

---

## 📱 TESTING PLATFORMS

### Android (Minimum)
- Min SDK 21 (Android 5.0 Lollipop)
- Test on: Emulator API 21+ OR Device Android 5.0+

### iOS (Minimum)
- Min iOS 11.0
- Test on: Simulator iOS 11+ OR Device iOS 11+

### Web (Optional)
- Chrome, Firefox, Safari (latest)
- Run with: `flutter run -d chrome`

---

## 🎯 NEXT STEPS

1. **Verify Environment**
   ```bash
   flutter doctor
   ```

2. **Clone Project**
   ```bash
   git clone <repo>
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Firebase**
   ```bash
   flutterfire configure
   ```

5. **Run App**
   ```bash
   flutter run
   ```

6. **Build Release**
   ```bash
   flutter build apk --release
   flutter build ios --release
   ```

---

## 📞 QUICK LINKS

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Console**: https://console.firebase.google.com
- **Android SDK Manager**: Open Android Studio → SDK Manager
- **Xcode Downloads**: App Store → Search "Xcode"

---

## ✅ YOU'RE READY IF YOU HAVE:

- ✅ Flutter 3.11.3+
- ✅ Dart 3.11.3+
- ✅ Android SDK 21+ (or Xcode for iOS)
- ✅ JDK 17+
- ✅ Firebase project created
- ✅ Configuration files downloaded
- ✅ 10GB+ disk space available
- ✅ 4GB+ RAM

**That's all you need! 🚀**

---

For detailed requirements, see `MINIMUM_REQUIREMENTS.md`

