# Tourneez

Tourneez is a Flutter app for creating and running local sports tournaments and leagues. You can manage teams and venues, generate fixtures, schedule rounds, record scores, and view standings — all on-device, with no account or server required.

## 2a) How to access the current prototype of your computational artifact

The current prototype is this public GitHub repository:

**https://github.com/mrmcwrong/Tourneez**

There is no hosted website or app-store build yet. To access the prototype:

1. Open the repository in a browser to browse the source, issues, and commit history.
2. Download a ZIP from the green **Code** button, or clone it with Git:

```bash
git clone https://github.com/mrmcwrong/Tourneez.git
cd Tourneez
```

The runnable prototype is the Flutter project in this repository. After cloning, follow section 2b to install dependencies and launch the app on Windows, Chrome, or a connected device.

## 2b) How to install and run your current prototype of your computational artifact

### Prerequisites

- [Git](https://git-scm.com/)
- [Flutter](https://docs.flutter.dev/get-started/install) with Dart **3.11 or newer** (the version that ships with a current Flutter stable SDK)
- A target platform toolchain:
  - **Windows desktop:** Visual Studio with the “Desktop development with C++” workload
  - **Web:** Google Chrome
  - **Android:** Android Studio / an Android emulator or USB-connected phone
  - **iOS:** Xcode (macOS only)

Confirm Flutter can see a device:

```bash
flutter doctor
flutter devices
```

### Install

```bash
git clone https://github.com/mrmcwrong/Tourneez.git
cd Tourneez
flutter pub get
```

### Run

From the project root, start the prototype on any listed device:

```bash
flutter run
```

To pick a platform explicitly:

```bash
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

The first Windows or Android build can take several minutes. After that, the app opens on the home screen. Create teams and venues, then start a tournament to use schedule, scores, and standings.

Optional checks:

```bash
flutter analyze
flutter test
```
