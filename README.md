# Radhika Mineral Water - Flutter App (Starter)

This repository is a starter Flutter app for Radhika Mineral Water. It provides:
- Dashboard-style home (summary metrics, action buttons, modular navigation)
- Riverpod state management
- Firebase placeholders for Auth, Firestore, Functions, Messaging
- Cloud Function for sequential monthly bill numbers (RMW-YYYY-MM-SEQ)
- Mock data and PDF bill generation scaffold

## Setup
1. Install Flutter SDK.
2. Create Firebase project and add Android/iOS apps.
3. Place `google-services.json` (android) and `GoogleService-Info.plist` (iOS) in platform folders or run `flutterfire configure`.
4. Run:
   ```
   flutter pub get
   flutter run -d chrome   # or your device
   ```

## Notes
- Replace placeholders in `lib/services/firebase_service.dart`.
- Deploy cloud functions in `functions/` using Node 18+:
  ```
  cd functions
  npm install
  firebase deploy --only functions
  ```
