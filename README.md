# Calculator

A Flutter calculator with a **simple mode** and an **advanced scientific mode**,
four color themes, calculation history, and settings that persist across app restarts.

Built with Flutter and `shared_preferences`, organized as a small clean-architecture
project (domain / data / presentation).

## Features

### Simple mode
- Basic arithmetic: `+` `−` `×` `÷`
- Percent `%`, backspace `⌫`, clear `AC`

### Advanced mode (toggle in the app bar)
- Trigonometric functions: `sin` `cos` `tan` `asin` `acos` `atan` (computed in **degrees**)
- Logarithms: `ln` `log`, square root `√`
- Powers: `^`, square `^2`, factorial `!`
- Constants: `π`, `e`
- Parentheses and unary minus (`−5 + 3 = −2`)

### Themes
Four themes switchable from the palette menu in the app bar:

| Theme     | Brightness |
| --------- | ---------- |
| Light     | light      |
| Dark      | dark       |
| Solarized | light      |
| Cyberpunk | dark       |

### History
- Remembers the last **20 calculations** (expression + result + time)
- Tap any entry to restore the expression and result
- Clear the whole history with one button
- Newest entries appear first

### Persistence
Your **theme**, **mode** (simple/advanced) and **history** are saved with
`shared_preferences` and restored automatically the next time the app opens.

## Getting started

```bash
flutter pub get
flutter run          # run on a connected device/emulator
flutter test         # 18 widget tests
```

## Building a release APK

```bash
flutter build apk --split-per-abi
```

Output (in `build/app/outputs/flutter-apk/`):

| File                            | Architecture              |
| ------------------------------- | ------------------------- |
| `app-arm64-v8a-release.apk`     | 64-bit ARM (most phones)  |
| `app-armeabi-v7a-release.apk`   | 32-bit ARM                |
| `app-x86_64-release.apk`        | 64-bit x86 (emulators)    |

Install on a phone:

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

> **Signing:** release builds are signed with a keystore referenced by
> `android/key.properties` (this file is **git-ignored** — never commit it).
> On a fresh clone, copy `android/key.properties` and your `.jks` keystore over,
> otherwise the build falls back to debug signing.

## Project structure

```
lib/
├── main.dart                          # entry point (runApp) + public API re-exports
├── app.dart                           # root widget: theme state + MaterialApp
├── core/
│   └── theme/
│       └── app_theme.dart             # AppThemeOption + AppThemes (4 themes)
└── features/
    └── calculator/
        ├── domain/                    # pure logic, no Flutter UI
        │   ├── expression_evaluator.dart   # expression parser & evaluator
        │   └── history_entry.dart          # history row model
        ├── data/                      # persistence
        │   └── settings_repository.dart    # all shared_preferences access
        └── presentation/              # UI
            ├── calculator_screen.dart      # screen: state + keypad layout
            └── widgets/
                ├── calculator_button.dart   # animated key button
                ├── display_panel.dart       # expression + result display
                └── history_drawer.dart      # history side drawer
```

## Dependencies

- [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.5.5`
- `flutter_lints` `^6.0.0` (dev, analysis)

## Tests

`test/widget_test.dart` covers arithmetic, division by zero, unary minus, powers,
factorials, trig functions (degrees), square root, log, π, mode switching,
theme switching, and persistence (mode + theme).
