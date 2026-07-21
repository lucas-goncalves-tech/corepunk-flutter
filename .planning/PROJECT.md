# Project: Corepunk Help App (Flutter Multi-platform)

## Summary
Cross-platform clone of [Corepunk Help](https://corepunk.help/) built with Flutter (Dart 3) and Riverpod 2.x, targeting both **Android Mobile** and **Windows Desktop (Windows 10/11)**.

## User Persona & Context
- Developer: New to Flutter (background in TypeScript/Express/Java).
- Strategy: Micro-incremental steps with strict approval gates at each component (Header -> Filter Bar -> Card -> Grid -> Detail Modal -> Navigation).
- Interface Language: 100% pt-BR (Portuguese Brazil).

## Tech Stack
- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: Riverpod 2.x (`flutter_riverpod`)
- **HTTP Client**: Dio / http
- **Target Platforms**: 
  - Android (AVD Emulator)
  - Windows Desktop (Win32 C++ Native `.exe` for Win 10 & 11)
- **UI Theme**: Corepunk Dark Fantasy Theme (Gold `#D5B97D`, Dark `#0A0A0A`)
