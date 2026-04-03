# 🔥 Firebase Setup Guide for SecureChat

Follow these steps to configure the backend for your Flutter app.

## 1. Create Project
1. Go to [console.firebase.google.com](https://console.firebase.google.com/)
2. Click **Create a project**
3. Name it `secure-chat-app` (or similar)
4. Toggle Google Analytics (optional, recommended off for simple dev)
5. Click **Create Project**

## 2. Enable Services (Critical Step!)
You must enable these services in the console *before* running the app, or it will crash.

### A. Authentication
1. Go to **Build** -> **Authentication**
2. Click **Get Started**
3. Select **Email/Password** -> Enable -> Save
4. Click **Add new provider** -> **Google** -> Enable
   - Provide a support email
   - Click Save

### B. Firestore Database
1. Go to **Build** -> **Firestore Database**
2. Click **Create Database**
3. Choose a location (e.g., `nam5` for us-central)
4. Start in **Test Mode** (we will update rules later)
5. Click **Create**

### C. Storage
1. Go to **Build** -> **Storage**
2. Click **Get Started**
3. Start in **Test Mode**
4. Click **Done**

## 3. Link to Flutter App
We will use the FlutterFire CLI, which is already referenced in your project.

### Prerequisites (Run in Terminal)
1. Install Firebase CLI (if not installed):
   ```bash
   npm install -g firebase-tools
   ```
2. Login to Firebase:
   ```bash
   firebase login
   ```
3. Activate FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

### Configuration Command
Run this command in your project root (`D:\chatapp`):

```bash
flutterfire configure
```

1. Select your new project (`secure-chat-app`)
2. Select platforms: `android`, `ios`, `web` (use arrow keys and spacebar)
3. When asked to override `lib/firebase_options.dart`, select **YES**

## 4. Final Verification
1. Open `lib/firebase_options.dart`
2. Ensure the `apiKey`, `projectId`, and `appId` fields are populated with real values, not placeholders like `YOUR_API_KEY`.

## 5. Security Rules (Deploy Later)
Once your app is working, update your Firestore Rules to:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User secure access
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // General fallback (remove before production)
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

