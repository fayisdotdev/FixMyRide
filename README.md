# FixMyRide

A Flutter-based mobile application for vehicle maintenance and repair management.

## Tech Stack

- **Frontend Framework**: Flutter (^3.7.0)
- **Programming Language**: Dart
- **State Management**: GetX (^4.7.2)
- **Authentication**: Firebase Auth (^5.5.3)
- **Database**: Cloud Firestore (^5.6.7)
- **Backend Services**: Firebase Core (^3.13.0)
- **Location Services**: Geolocator (^14.0.0)
- **Networking**: HTTP (^1.4.0)
- **UI Components**:
  - Material Design
  - Cupertino Icons (^1.0.8)
  - Google Fonts (^6.2.1)
- **Development Tools**: Flutter Launcher Icons (^0.14.3)

## Features

- User Authentication
- Vehicle Management
- Location-based Services
- Cross-platform Support (Android and Web)

## Project Structure

```
fixmyride/
├── lib/             # Dart source code
├── android/         # Android-specific code
├── ios/            # iOS-specific code
├── web/            # Web platform code
├── assets/         # Static assets
│   └── icons/      # App icons
├── test/           # Test files
└── windows/        # Windows platform code
```

## Setup Instructions

### Prerequisites

1. Install Flutter (version 3.7.0 or later)
2. Install Dart (version 3.x or later)
3. Android Studio or VS Code with Flutter extensions
4. Git
5. Firebase account and project setup

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/fixmyride.git
cd fixmyride
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a Firebase project
   - Add your Android/iOS apps in Firebase console
   - Download and add configuration files:
     - Android: `google-services.json`
     - iOS: `GoogleService-Info.plist`

4. Run the application
```bash
flutter run
```

## Supported Platforms

- Android
- iOS
- Web
- Windows
- Linux
- macOS

## Building for Production

### Android
```bash
flutter build apk --release
```

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Acknowledgments

- Flutter Team
- Firebase
- GetX Team

## ScreenShots
https://drive.google.com/drive/folders/19eqRhqdsJazo8SqZP62mRsSlSI4mOFMR?usp=drive_link 
