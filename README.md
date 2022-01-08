# health

Health Application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

- [Google Play](https://play.google.com/store/apps/details?id=com.aqua.better.life)
- [Google Play](https://apps.apple.com/cn/app/aqua-calm-your-mind-and-body/id1564410552)
For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# build APk
    flutter build apk --obfuscate --split-debug-info=./symbols
# build IOS
    flutter build ios --obfuscate --split-debug-info=./symbols
# build moor database model
    flutter packages pub run build_runner build
