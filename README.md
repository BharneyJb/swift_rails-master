# SwiftRails - Train Ticketing App 🚆

> A comprehensive, modern mobile application for seamless train travel booking and management, built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![GetX](https://img.shields.io/badge/State_Management-GetX-purple)
![Platform](https://img.shields.io/badge/Platform-iOS_%7C_Android-grey)
![License](https://img.shields.io/badge/License-ISC-green)

## 📋 Table of Contents
- [Introduction](#introduction)
- [Key Features](#key-features)
- [App Screenshots](#app-screenshots)
- [Technology Stack](#technology-stack)
- [Project Architecture](#project-architecture)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Backend Integration](#backend-integration)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [Contact](#contact)

## 📖 Introduction
**SwiftRails Mobile** is the client-facing application for the SwiftRails ecosystem. It empowers users to search for trains, view schedules, select specific seats in real-time, make secure payments, and manage their travel itinerary—all from a sleek, intuitive interface.

Designed with a focus on user experience (UX), the app features smooth animations, clear navigation, and robust error handling.

## ✨ Key Features

### 🔐 Authentication & Profile
- **Secure Login/Sign Up**: JWT-based authentication flow.
- **Profile Management**: Update personal details (Name, Email, Phone).
- **Avatar Support**: Upload and view profile pictures.

### 🚆 Travel Booking
- **Smart Search**: Find trains by Source, Destination, and Travel Date.
- **Live Schedules**: View up-to-date train timings and stops.
- **Visual Seat Selection**: Interactive coach layout to pick your preferred seat.
- **Passenger Details**: Add multiple passengers to a single booking.

### 💳 Payments & Tickets
- **Secure Payments**: Integrated payment gateway (Paystack).
- **Digital Tickets**: QR code generation for easy check-in.
- **Booking History**: Access upcoming and past trips.
- **Cancellations**: Easy cancellation process for booked tickets.

### 🔔 Notifications
- **Real-time Updates**: Push notifications for booking status and schedule changes.

## 🛠 Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [GetX](https://pub.dev/packages/get) (Routes, Dependency Injection, State)
- **Networking**: [Dio](https://pub.dev/packages/dio) (HTTP Client with Interceptors)
- **Local Storage**: [GetStorage](https://pub.dev/packages/get_storage) (Persisting tokens/user data)
- **UI/UX**: 
  - [Google Fonts](https://pub.dev/packages/google_fonts)
  - [Iconsax](https://pub.dev/packages/iconsax)
  - [Flutter Animate](https://pub.dev/packages/flutter_animate)
- **Payment**: [Flutter Paystack](https://pub.dev/packages/flutter_paystack)

## 🏗 Project Architecture
The project follows a modular **GetX Pattern** structure for scalability and maintainability.

```
lib/
├── app/
│   ├── bindings/       # Dependency injection bindings
│   ├── config/         # App configuration (Theme, Strings, Net)
│   ├── core/           # Core utilities
│   │   ├── services/   # API, Storage, Global Services
│   │   └── utils/      # Helpers, Constants, Validators
│   ├── data/           # Data layer
│   │   ├── models/     # Data models (User, Train, Booking)
│   │   └── providers/  # api_provider (if separated)
│   ├── modules/        # Feature modules (Screens + Controllers)
│   │   ├── auth/       # Login, Register, Forgot Password
│   │   ├── home/       # Dashboard, Search
│   │   ├── booking/    # Seat selection, Passenger details
│   │   ├── profile/    # User settings
│   │   └── ...
│   └── routes/         # App navigation routes
└── main.dart           # App entry point
```

## ✅ Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- An Android Emulator or iOS Simulator

## 🚀 Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/tessyjonburica/swift_rails-master.git
   cd swift_rails-master
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   # Run on default connected device
   flutter run

   # Run specifically on iOS Simulator
   flutter run -d A625C... (Device ID)
   ```

## 🔗 Backend Integration
This app connects to the **SwiftRails Node.js Backend**.

1. **Start the Backend Server** (See backend README).
2. **Configure Base URL**:
   Open `lib/app/core/utils/api_endpoints.dart`:
   ```dart
   class ApiEndpoints {
     // Use localhost for simulators, or local IP (e.g., 192.168.1.5) for physical devices
     static const String baseUrl = 'http://localhost:3000'; 
     // ...
   }
   ```
   *Note: Android Emulator often requires `10.0.2.2` instead of `localhost`.*

## ⚙️ Configuration

### Android Permissions
Ensure `AndroidManifest.xml` has Internet permission:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
For local dev (HTTP), allow cleartext traffic:
```xml
<application android:usesCleartextTraffic="true" ...>
```

### iOS Configuration
Ensure `Info.plist` allows arbitrary loads for local HTTP development:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🤝 Contributing
We welcome contributions!
1. Fork the repo.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Open a Pull Request.

## 📩 Contact
**SwiftRails Team**
- GitHub: [https://github.com/tessyjonburica](https://github.com/tessyjonburica)

---
*Developed with ❤️ using Flutter*
