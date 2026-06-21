# DevPulse 📱

> A developer-focused tech news reader with personal bookmarks, dark/light theme, and live search — built with Flutter and Firebase.

**Live Demo:** https://devpulse-af21b.web.app
**Video:** https://youtu.be/rlaa3ziBjO0

---

## Screenshots

<img width="1920" height="1080" alt="Screenshot 1" src="https://github.com/user-attachments/assets/eb0816da-8c0b-4132-ad53-98e45136a4a8" />
<img width="1920" height="1080" alt="Screenshot 2" src="https://github.com/user-attachments/assets/1ce137d0-96ba-4c17-bcbb-55376316cc64" />
<img width="1920" height="1080" alt="Screenshot 3" src="https://github.com/user-attachments/assets/f2a245e8-569d-4a78-ba5c-5230290efb50" />
<img width="1920" height="1080" alt="Screenshot 4" src="https://github.com/user-attachments/assets/d9f9d44e-0dec-4552-b6f6-ab52fc99cc89" />

---

## Features

- 🔐 Email/Password Authentication (Firebase Auth)
- 📰 Live tech news feed via the **dev.to API**
- 🔖 Personal bookmarks saved to cloud (Firestore)
- 🌗 Dark / Light theme toggle with saved preference
- 🔍 Search bar to find specific news
- 🏷️ Category filters — Technology, AI, Crypto, Science, Gaming
- ⚡ Shimmer loading animations
- 🔄 Pull-to-refresh news feed
- 👤 Profile screen with bookmark count
- 🌐 Open full articles in browser
- 📤 Share articles
- 📡 Offline-friendly: caches the last successful feed per category/search so the app still shows articles with no connection

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| News API | [dev.to API](https://developers.forem.com/api) (REST, no key required) |
| State Management | Riverpod |
| Architecture | Repository pattern over services |
| Local Cache | SharedPreferences |
| Hosting | Firebase Hosting |

---

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart        # API base URLs, env config
│   └── errors/
│       └── app_exception.dart     # Sealed exception hierarchy
├── data/
│   └── repositories/
│       ├── auth_repository.dart
│       ├── bookmark_repository.dart
│       └── news_repository.dart
├── models/
│   └── article.dart                # Article data model
├── providers/
│   ├── repository_providers.dart   # Riverpod repository providers
│   ├── service_providers.dart      # Riverpod service providers
│   └── theme_provider.dart         # Dark/light theme state
├── services/
│   ├── auth_service.dart           # Firebase authentication
│   ├── news_service.dart           # dev.to API + offline cache
│   └── firestore_service.dart      # Bookmark CRUD operations
├── screens/
│   ├── login_screen.dart           # Login & signup
│   ├── home_screen.dart            # News feed + search + categories
│   ├── article_detail_screen.dart  # Full article view
│   ├── bookmarks_screen.dart       # Saved articles
│   └── profile_screen.dart         # User profile + settings
└── widgets/
    ├── article_card.dart           # Reusable news card
    └── shimmer_card.dart           # Loading skeleton
```

---

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/gamerboyadarsh-dot/devpulse.git
cd devpulse
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Set up Firebase
- Go to [console.firebase.google.com](https://console.firebase.google.com)
- Create project → Add Android app (package: `com.example.devpulse`)
- Enable **Authentication → Email/Password**
- Enable **Firestore Database**
- Run:
```bash
flutterfire configure
```
- Deploy the included security rules so bookmarks are private per-user:
```bash
firebase deploy --only firestore:rules
```

### 4. News API
No key needed — the app calls the public [dev.to API](https://developers.forem.com/api) directly.

### 5. Run the app
```bash
flutter run
```

---

## Deployment

Deployed on Firebase Hosting:
```bash
flutter build web --release
firebase deploy
```

Live at: https://devpulse-af21b.web.app

---

## Developer

**Adarsh Agrawal**
B.Tech CSE (AI & Robotics) — VIT Chennai (2024–2028)
GitHub: [@gamerboyadarsh-dot](https://github.com/gamerboyadarsh-dot)

---

## License

This project was built as part of the VIT Android Club Technical Recruitment 2026.
