# Project State

## Current Position
- **Active Milestone**: Milestone 2 (Items Database UI)
- **Active Branch**: `feat/item-card-component`
- **Active Phase**: Phase 2.5 (Item Grid Body & API Riverpod Integration)
- **Status**: Real Corepunk API (`GET /api/items/by-category`) integrated with Riverpod `FutureProvider.family` for automatic TanStack Query-style memory caching! Awaiting user review/approval on Android Emulator.

## Decisions Log
- Target Platforms: Android Emulator (AVD) + Windows Desktop (Win 10/11)
- UI Language: 100% pt-BR (Português Brasil)
- State Management: Riverpod 2.x (`FutureProvider.family` + `ItemFilters` comparator for automatic cache keys).
- HTTP Client: `http` package fetching from `https://corepunk.help/api/items/by-category`.

## Pending Verification / Gates
- Gate 2.5: User visual & functional approval of Real API Integration with Riverpod Cache.
