HEAD
# DevPulse 📱

> A developer-focused tech news reader with personal bookmarks, dark/light theme, and live search — built with Flutter and Firebase.

**Live Demo:** https://devpulse-af21b.web.app

---
VideoLink:https://youtu.be/rlaa3ziBjO0

## Screenshots


> *(Add screenshots here after taking them — Win + G to record screen)*

---





<img width="1920" height="1080" alt="Screenshot (598)" src="https://github.com/user-attachments/assets/eb0816da-8c0b-4132-ad53-98e45136a4a8" />

<img width="1920" height="1080" alt="Screenshot (601)" src="https://github.com/user-attachments/assets/1ce137d0-96ba-4c17-bcbb-55376316cc64" />

<img width="1920" height="1080" alt="Screenshot (598)" src="https://github.com/user-attachments/assets/f2a245e8-569d-4a78-ba5c-5230290efb50" />

<img width="1920" height="1080" alt="Screenshot (600)" src="https://github.com/user-attachments/assets/d9f9d44e-0dec-4552-b6f6-ab52fc99cc89" />
#Feautures

- 🔐 Email/Password Authentication (Firebase Auth)
- 📰 Live tech news feed via GNews API
- 🔖 Personal bookmarks saved to cloud (Firestore)
- 🌗 Dark / Light theme toggle with saved preference
- 🔍 Search bar to find specific news
- 🏷️ Category filters — Technology, AI, Crypto, Science, Gaming
- ⚡ Shimmer loading animations
- 🔄 Pull-to-refresh news feed
- 👤 Profile screen with bookmark count
- 🌐 Open full articles in browser
- 📤 Share articles

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| News API | GNews API (REST) |
| State Management | Provider |
| Hosting | Firebase Hosting |

---
lib/

├── models/

│   └── article.dart          # Article data model

├── providers/

│   └── theme_provider.dart   # Dark/light theme state

├── services/

│   ├── auth_service.dart     # Firebase authentication

│   ├── news_service.dart     # GNews API + offline cache

│   └── firestore_service.dart # Bookmark CRUD operations

├── screens/

│   ├── login_screen.dart     # Login & signup

│   ├── home_screen.dart      # News feed + search + categories

│   ├── article_detail_screen.dart # Full article view

│   ├── bookmarks_screen.dart # Saved articles

│   └── profile_screen.dart   # User profile + settings

└── widgets/

├── article_card.dart     # Reusable news card

└── shimmer_card.dart     # Loading skeleton
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
- Enable **Firestore Database → Test mode**
- Run:
```bash
flutterfire configure
```

### 4. Add dev API key
- Get free key at 


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

## Project Structure
=======
DevPulse 📱
A developer-focused tech news reader with personal bookmarks, dark/light theme, and live search — built with Flutter and Firebase.

Live Demo: https://devpulse-af21b.web.app

Screenshots
(Add screenshots here after taking them — Win + G to record screen)

Features
🔐 Email/Password Authentication (Firebase Auth)
📰 Live tech news feed via GNews API
🔖 Personal bookmarks saved to cloud (Firestore)
🌗 Dark / Light theme toggle with saved preference
🔍 Search bar to find specific news
🏷️ Category filters — Technology, AI, Crypto, Science, Gaming
⚡ Shimmer loading animations
🔄 Pull-to-refresh news feed
👤 Profile screen with bookmark count
🌐 Open full articles in browser
📤 Share articles
Tech Stack
Layer	Technology
Framework	Flutter (Dart)
Authentication	Firebase Auth
Database	Cloud Firestore
News API	GNews API (REST)
State Management	Provider
Hosting	Firebase Hosting
lib/

├── models/

│ └── article.dart # Article data model

├── providers/

│ └── theme_provider.dart # Dark/light theme state

├── services/

│ ├── auth_service.dart # Firebase authentication

│ ├── news_service.dart # GNews API + offline cache

│ └── firestore_service.dart # Bookmark CRUD operations

├── screens/

│ ├── login_screen.dart # Login & signup

│ ├── home_screen.dart # News feed + search + categories

│ ├── article_detail_screen.dart # Full article view

│ ├── bookmarks_screen.dart # Saved articles

│ └── profile_screen.dart # User profile + settings

└── widgets/

├── article_card.dart # Reusable news card

└── shimmer_card.dart # Loading skeleton
Setup Instructions
1. Clone the repository
git clone https://github.com/gamerboyadarsh-dot/devpulse.git
cd devpulse
2. Install dependencies
flutter pub get
3. Set up Firebase
Go to console.firebase.google.com
Create project → Add Android app (package: com.example.devpulse)
Enable Authentication → Email/Password
Enable Firestore Database → Test mode
Run:
flutterfire configure
4. Add GNews API key
Get free key at gnews.io
Replace YOUR_GNEWS_KEY_HERE in lib/services/news_service.dart
5. Run the app
flutter run
Deployment
Deployed on Firebase Hosting:

flutter build web --release
firebase deploy
Live at: https://devpulse-af21b.web.app

Developer
Adarsh Agrawal B.Tech CSE (AI & Robotics) — VIT Chennai (2024–2028) GitHub: @gamerboyadarsh-dot

License
This project was built as part of the VIT Android Club Technical Recruitment 2026.

Project Structure
