# 📋 UCHAT - Minimum Requirements to Run

## 🖥️ SYSTEM REQUIREMENTS

### Windows
- **OS**: Windows 10 or later
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 5GB free space
- **Processor**: Intel i5 or equivalent

### macOS
- **OS**: macOS 10.15 (Catalina) or later
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 5GB free space
- **Processor**: Intel or Apple Silicon (M1/M2)

### Linux
- **OS**: Ubuntu 18.04 or later (or equivalent)
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 5GB free space
- **Processor**: x86_64 architecture

---

## 📦 SOFTWARE REQUIREMENTS

### Essential Tools

#### 1. **Flutter SDK** (Required)
- **Version**: 3.11.3 or later
- **Download**: https://flutter.dev/docs/get-started/install
- **Setup**: Add Flutter to PATH environment variable

#### 2. **Dart SDK** (Included with Flutter)
- **Version**: 3.11.3 or later
- **Automatically installed** with Flutter

#### 3. **Git** (Required for cloning)
- **Version**: 2.25 or later
- **Download**: https://git-scm.com/download

### Android Development

#### 4. **Android Studio** (Recommended)
- **Version**: 2021.1 or later
- **Download**: https://developer.android.com/studio

#### 5. **Android SDK**
- **Min SDK Version**: 21 (Android 5.0)
- **Target SDK Version**: 36 (Android 15)
- **Compiled SDK Version**: 36
- **Include**: Build Tools, Emulator

#### 6. **Android NDK**
- **Included** automatically by Flutter

#### 7. **Java Development Kit (JDK)**
- **Version**: 17 or later
- **Type**: OpenJDK 17 recommended

### iOS Development (macOS only)

#### 8. **Xcode** (Required for iOS)
- **Version**: 14.0 or later
- **Download**: App Store

#### 9. **iOS Deployment Target**
- **Min Version**: iOS 11.0 or later
- **Latest Target**: iOS 17.0 recommended

#### 10. **CocoaPods** (Dependency manager)
- **Version**: 1.11 or later
- **Install**: `sudo gem install cocoapods`

---

## ☁️ BACKEND REQUIREMENTS

### Firebase Project (Required)
- **Firebase Account**: Free tier or paid plan
- **Services Needed**:
  1. **Firebase Authentication** - Email & Google Sign-In
  2. **Cloud Firestore** - Database
  3. **Firebase Storage** - Image/media storage
  4. **Firebase Messaging** - Push notifications

### Configuration Files Required
1. **Android**: `google-services.json` (in `android/app/`)
2. **iOS**: `GoogleService-Info.plist` (in `ios/Runner/`)

---

## 💾 HARDWARE REQUIREMENTS

### Minimum (Development)
- **CPU**: Dual-core processor
- **RAM**: 4GB
- **Disk**: 10GB SSD
- **Display**: 1366x768 resolution

### Recommended
- **CPU**: Quad-core or higher
- **RAM**: 8GB or more
- **Disk**: 20GB+ SSD
- **Display**: 1920x1080 or higher

### For Testing
- **Emulator**: 2GB+ dedicated RAM
- **Physical Device**: Android 5.0+ or iOS 11+

---

## 📱 TARGET PLATFORMS & VERSIONS

### Android
- **Min SDK**: 21 (API Level 21) - Android 5.0 Lollipop
- **Target SDK**: 36 (API Level 36) - Android 15.0
- **Test Devices**: Android 5.0+ or Emulator API 21+

### iOS
- **Min iOS**: 11.0
- **Target iOS**: 17.0+
- **Test Devices**: iPhone 6s+ or Simulator iOS 11+

### Web (Optional)
- **Browser**: Chrome, Firefox, Safari (latest versions)
- **Minimum**: ES6 support

---

## 🔧 DEVELOPMENT TOOLS (Optional)

### Editors
- **Visual Studio Code** (Lightweight, recommended)
  - Extensions: Flutter, Dart
- **Android Studio** (Heavyweight but full-featured)
- **IntelliJ IDEA** with Flutter plugin
- **JetBrains Fleet** (New option)

### Command-line Tools
- **PowerShell** (Windows) or **Terminal** (macOS/Linux)
- **Git** for version control

---

## 📚 DEPENDENCIES SUMMARY

### Core Dependencies (Auto-installed)
```
Flutter Framework
├─ Material Design UI
├─ Dart Standard Library
└─ Foundation classes

Total Packages: 60+ (managed by pubspec.yaml)
```

### Key External Packages
- **Firebase**: 5 packages (auth, firestore, storage, messaging, core)
- **State Management**: Riverpod (2 packages)
- **Navigation**: Go Router
- **UI**: Cached Images, Emoji Picker, Lottie, Google Fonts
- **Security**: Encryption libraries
- **Storage**: Hive, Secure Storage
- **Utilities**: UUID, Intl, TimeAgo, Permission Handler

---

## 🚀 QUICK START - MINIMUM STEPS

### 1. Install Flutter & Dart
```bash
# Download Flutter SDK from https://flutter.dev
# Extract to your preferred location
# Add Flutter/bin to PATH

# Verify installation
flutter --version
dart --version
```

### 2. Clone the Project
```bash
git clone <repository-url>
cd chatapp
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Firebase
```bash
# Option A: Automatic setup (recommended)
flutterfire configure

# Option B: Manual setup
# Add google-services.json to android/app/
# Add GoogleService-Info.plist to ios/Runner/
```

### 5. Run the App
```bash
# On Android
flutter run

# On iOS (macOS only)
flutter run -t lib/main.dart

# On web
flutter run -d chrome

# Release build
flutter build apk --release
flutter build ios --release
```

---

## 📋 PRE-FLIGHT CHECKLIST

Before running the app, verify:

### Environment Setup
- [ ] Flutter installed (3.11.3+)
- [ ] Dart installed (3.11.3+)
- [ ] Git installed
- [ ] PATH variables set correctly

### Android Setup
- [ ] Android SDK installed
- [ ] Min SDK 21 available
- [ ] Target SDK 36 available
- [ ] JDK 17+ installed
- [ ] Android emulator or device available

### iOS Setup (macOS only)
- [ ] Xcode installed (14.0+)
- [ ] iOS deployment target 11.0+
- [ ] CocoaPods installed
- [ ] iOS simulator or device available

### Firebase Setup
- [ ] Firebase account created
- [ ] Project created in Firebase Console
- [ ] Firestore database enabled
- [ ] Authentication enabled
- [ ] google-services.json in android/app/
- [ ] GoogleService-Info.plist in ios/Runner/

### Project Setup
- [ ] Repository cloned
- [ ] `flutter pub get` executed
- [ ] firebase_options.dart generated
- [ ] No build errors

---

## 🔍 VERIFICATION COMMANDS

```bash
# Check Flutter/Dart versions
flutter --version

# Check all requirements
flutter doctor

# Check specific platform
flutter doctor --android
flutter doctor --ios

# Verify Firebase configuration
# Check for google-services.json in android/app/

# Test dependencies
flutter pub get --no-precompile

# Check code analysis
flutter analyze

# Run tests (if available)
flutter test
```

---

## ⚠️ COMMON ISSUES & SOLUTIONS

### Issue: "flutter: command not found"
**Solution**: Add Flutter to PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"  # macOS/Linux
# or set PATH in Windows environment variables
```

### Issue: Android SDK not found
**Solution**: Set ANDROID_HOME
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS/Linux
# Windows: Set ANDROID_HOME in environment variables
```

### Issue: iOS deployment target mismatch
**Solution**: Update iOS minimum
```bash
# In ios/Podfile, set:
platform :ios, '11.0'
```

### Issue: Firebase configuration missing
**Solution**: Run flutterfire configure
```bash
flutterfire configure --project=your-firebase-project
```

### Issue: Gradle build fails
**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 MINIMUM SPECIFICATIONS SUMMARY

| Category | Minimum | Recommended |
|----------|---------|-------------|
| **OS** | Windows 10/macOS 10.15/Ubuntu 18.04 | Latest version |
| **RAM** | 4GB | 8GB+ |
| **Storage** | 10GB | 20GB+ SSD |
| **Flutter** | 3.11.3 | Latest stable |
| **Android Min SDK** | 21 | 28+ |
| **Android Target SDK** | 36 | 36 |
| **iOS Min** | 11.0 | 15.0+ |
| **JDK** | 17 | 17+ |
| **Xcode** | 14.0 (macOS only) | Latest |

---

## 🎯 PLATFORM-SPECIFIC REQUIREMENTS

### Android Only
- Android SDK 21+
- Android Studio or command-line tools
- Android emulator OR physical device
- ~3GB disk space for SDK

### iOS Only (macOS Required)
- Xcode 14.0+
- macOS 10.15+
- ~5GB disk space for Xcode
- iOS 11.0+ device or simulator

### Both Android & iOS
- Dual-core processor minimum
- 8GB RAM recommended
- SSD with 20GB+ space
- ~8GB disk space total for SDKs

---

## 🔐 Firebase Project Setup (Required)

### Create Firebase Project
1. Go to https://console.firebase.google.com
2. Create new project or use existing
3. Enable Firestore Database
4. Enable Authentication (Email + Google)
5. Enable Storage
6. Enable Cloud Messaging
7. Download credentials files
8. Place files in correct locations

### Required Firebase Services
- ✅ Authentication
- ✅ Cloud Firestore
- ✅ Cloud Storage
- ✅ Cloud Messaging

---

## 📞 SUPPORT & RESOURCES

### Official Documentation
- **Flutter**: https://flutter.dev/docs
- **Firebase**: https://firebase.google.com/docs
- **Android**: https://developer.android.com/docs
- **iOS**: https://developer.apple.com/documentation

### Installation Guides
- Flutter Setup: https://flutter.dev/docs/get-started/install
- Android Setup: https://developer.android.com/studio/install
- Firebase Setup: https://firebase.google.com/docs/flutter/setup

### Troubleshooting
- Flutter Issues: https://flutter.dev/docs/testing/troubleshooting
- Firebase Issues: https://firebase.google.com/support
- Dart Packages: https://pub.dev

---

## ✅ FINAL CHECKLIST

Before launching the app:

- [ ] All system requirements met
- [ ] Flutter & Dart installed
- [ ] Android/iOS SDKs installed
- [ ] Firebase project created
- [ ] Configuration files in place
- [ ] Dependencies installed (`flutter pub get`)
- [ ] No build errors (`flutter analyze`)
- [ ] App runs successfully (`flutter run`)
- [ ] Firebase connectivity working
- [ ] Emulator/device ready

---

**Once all requirements are met, you're ready to run UCHAT! 🚀**

For the latest versions and updates, refer to official documentation links above.

