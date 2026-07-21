# Phase 1 Plan: Environment Setup & Dark Theme Scaffold

## Overview
Establish the Flutter development environment on Windows, create the Flutter project `corepunk_app`, configure Riverpod state management, and set up the Corepunk Dark Fantasy theme tokens.

## User Approval Gate
- **Gate 1**: Verify Flutter SDK & Android Emulator setup, run `flutter run` on Android emulator to confirm black/dark scaffold screen.

## Tasks

### Task 1: Environment Setup Verification
- **Goal**: Ensure Flutter SDK and Android Studio / AVD are installed and recognized on Windows.
- **Steps**:
  1. Download Flutter SDK for Windows & add `flutter/bin` to `PATH`.
  2. Install Android Studio + Android SDK Command-line Tools.
  3. Create & start an Android Virtual Device (AVD).
  4. Run `flutter doctor` to ensure zero blocking errors.

### Task 2: Flutter Project Initialization & Dependencies
- **Goal**: Scaffold clean Flutter project and configure `pubspec.yaml`.
- **Files**:
  - `pubspec.yaml`
  - `lib/main.dart`
- **Dependencies**:
  - `flutter_riverpod: ^2.5.0`
  - `dio: ^5.4.0`
  - `google_fonts: ^6.1.0`

### Task 3: Corepunk Dark Theme Design System
- **Goal**: Define color palette, typography, and card decoration styles.
- **Files**:
  - `lib/core/theme/app_colors.dart`
  - `lib/core/theme/app_theme.dart`
- **Theme Tokens**:
  - Dark Background: `#0F1218`
  - Card Surface: `#171C26`
  - Accent Gold: `#E5A93C`
  - Rarity Colors: Common (`#9D9D9D`), Rare (`#0070DD`), Epic (`#A335EE`), Legendary (`#FF8000`)

## Verification Criteria
- `flutter doctor` shows green checkmarks for Flutter & Android toolchain.
- App launches successfully on Android Emulator displaying Corepunk Dark Theme.
