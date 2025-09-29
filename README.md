# App Screen Privacy

[![pub version](https://img.shields.io/pub/v/app_screen_privacy.svg)](https://pub.dev/packages/app_screen_privacy)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin to protect your app's screen from being captured or recorded. This plugin provides a privacy screen that is displayed when the app is in the background or when a screenshot is attempted.

## Features

- **Privacy Screen:** Displays a privacy screen when the app is in the background.
- **Screenshot Prevention:** Prevents users from taking screenshots or recording the screen (Android only).
- **Customizable:** Allows you to customize the privacy screen with your own logo and background color.

## Getting Started

To use this plugin, add `app_screen_privacy` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  app_screen_privacy: ^0.0.1
```

Then, run `flutter pub get` to install the plugin.

## Usage

To use the plugin, you need to initialize it in your `main.dart` file.

```dart
import 'package:app_screen_privacy/app_screen_privacy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    AppScreenPrivacy.init(
      logo: 'assets/images/privacy-lock.png',
      backgroundColor: '#FFFFFF',
      shouldPreventScreenShot: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Test for screen overlay with custom logo\n')),
      ),
    );
  }
}
```

### Customization

You can customize the privacy screen by providing a logo and a background color.

- `logo`: The path to your logo asset.
- `backgroundColor`: The background color of the privacy screen in hex format (e.g., '#FFFFFF').
- `shouldPreventScreenShot`: A boolean to enable or disable screenshot prevention (Android only).

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
