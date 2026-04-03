# 🔧 COMMAND REFERENCE - Quick Commands for Daily Use

## 🚀 Running the App

### Basic Run
```bash
cd D:\chatapp
flutter run -d emulator-5554
```

### Run with Release Mode (faster, no debugging)
```bash
flutter run -d emulator-5554 --release
```

### Run with Verbose Logging (for debugging)
```bash
flutter run -d emulator-5554 -v
```

---

## 🔧 Common Flutter Commands

### Clean & Rebuild
```bash
flutter clean
flutter pub get
flutter run -d emulator-5554
```

### Install APK Directly
```bash
flutter install -d emulator-5554
```

### List Connected Devices
```bash
flutter devices
```

### Run Flutter Tests
```bash
flutter test
```

### Build APK for Release
```bash
flutter build apk --release
```

---

## 🔥 Firebase Commands

### Login to Firebase
```bash
firebase login
```

### Set Active Project
```bash
firebase use chatapp-79e53
```

### Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### Deploy Everything
```bash
firebase deploy
```

### View Deployed Rules
```bash
firebase firestore:indexes
```

### Test Rules Locally (if using emulator)
```bash
firebase emulators:start --only firestore
```

---

## 📱 Emulator Commands

### Start Emulator
```bash
emulator -avd sdk_gphone64_x86_64
```

### Kill All Emulators
```bash
adb emu kill
```

### List Running Emulators
```bash
adb devices
```

### Clear App Data
```bash
adb shell pm clear com.chatapp
```

### View Logs
```bash
adb logcat -s flutter
```

---

## 🗂️ Important Files

| File | Purpose | Edit? |
|------|---------|-------|
| `pubspec.yaml` | Dependencies | ✏️ Yes (add new packages) |
| `firebase_options.dart` | Firebase config | ❌ Auto-generated |
| `google-services.json` | Google Services config | ❌ Auto-generated |
| `firestore.rules` | Security rules | ✏️ Yes (security) |
| `lib/main.dart` | App entry | ✏️ Yes (customization) |
| `.env.local` | Sensitive config | 🔒 Never commit |

---

## 🔐 Security Checklist

Before deployment:

```bash
# 1. Review rules
cat firestore.rules

# 2. Check Firebase Console
# Go to https://console.firebase.google.com/project/chatapp-79e53

# 3. Enable production rules
# See firestore.rules for production version

# 4. Set up backups
# In Firebase Console → Backups

# 5. Configure CORS (for web)
# Use gsutil to update Cloud Storage CORS
```

---

## 🐛 Debugging Commands

### View Flutter Logs
```bash
flutter logs
```

### View Android Logs
```bash
adb logcat -s flutter,D/
```

### View Network Logs
```bash
adb logcat | grep -i "firestore\|firebase"
```

### Connect to DevTools
```bash
# URL will be shown when you run the app
# Example: http://127.0.0.1:12484/devtools/?uri=...
```

---

## 📊 Performance Commands

### Check Build Size
```bash
flutter build apk --analyze-size
```

### Check Performance
```bash
flutter run --profile -d emulator-5554
```

### Check Memory Usage
```bash
flutter run
# Then in DevTools → Memory tab
```

---

## 🔄 Version Management

### Update Packages
```bash
flutter pub upgrade
```

### Update Specific Package
```bash
flutter pub upgrade firebase_core
```

### Get Latest Dependencies
```bash
flutter pub get
```

---

## 📦 Generating & Building

### Generate Models (if using freezed or similar)
```bash
flutter pub run build_runner build
```

### Watch for Changes (development)
```bash
flutter pub run build_runner watch
```

### Format Code
```bash
dart format lib/ --line-length 100
```

### Analyze Code
```bash
flutter analyze
```

---

## 🎯 Useful Snippets

### Clear All Caches
```bash
flutter clean
rmdir /s /q build
rmdir /s /q .dart_tool
flutter pub get
```

### Reset Emulator
```bash
emulator -avd sdk_gphone64_x86_64 -wipe-data
```

### Kill All Dart/Flutter Processes
```bash
taskkill /IM dart.exe /F
taskkill /IM flutter.bat /F
```

---

## 📞 Getting Help

### View Help for Any Command
```bash
flutter --help
flutter run --help
firebase --help
```

### Report Issues
```bash
# Collect diagnostics
flutter doctor -v

# View detailed error
flutter run -v 2>&1 | tee debug.log
```

---

## 💡 Pro Tips

1. **Speed up builds**: Use `--profile` instead of `--release` during development
2. **Faster emulator**: Use x86_64 emulator instead of ARM
3. **Save build time**: Keep emulator running between runs
4. **Watch changes**: Use `flutter pub run build_runner watch` for auto-generation
5. **Check logs**: Always check `flutter logs` first when debugging
6. **Use profiles**: Profile your app with `--profile` before optimizing

---

## 🎓 Example Workflows

### Daily Development
```bash
# 1. Start emulator
emulator -avd sdk_gphone64_x86_64

# 2. Run app with hot reload
flutter run -d emulator-5554

# 3. Make code changes (hot reload with 'r')

# 4. Deploy changes to Firebase
firebase deploy --only firestore:rules

# 5. Kill emulator when done
adb emu kill
```

### Testing New Features
```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Run tests
flutter test

# 3. Build APK
flutter build apk --release

# 4. Test on emulator
flutter install -d emulator-5554

# 5. Commit and push
git add .
git commit -m "feat: new feature"
git push origin feature/new-feature
```

### Deployment
```bash
# 1. Update version
# Edit pubspec.yaml

# 2. Update rules if needed
firebase deploy --only firestore:rules

# 3. Build release APK
flutter build apk --release

# 4. Sign APK (if not auto-signed)
# See Flutter docs for signing

# 5. Upload to Play Store
# Use Play Console
```

---

**Save this file for quick reference!** 📌

Generated: 2026-03-24  
Project: Flutter Secure Chat App

