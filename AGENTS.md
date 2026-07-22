# AGENTS.md - Corepunk Mobile (Flutter)

Welcome to **Corepunk Mobile**, a high-performance cross-platform Flutter companion application for the MMORPG **Corepunk**.

This document serves as the primary orientation guide for AI agents and human developers working on this codebase.

---

## 📌 Project Overview

- **Name**: Corepunk Mobile (`corepunk-flutter`)
- **Framework**: Flutter (Dart 3)
- **Target Platforms**: Android (AVD Emulator) & Windows Desktop (`.exe`)
- **State Management**: Flutter Riverpod 2.x (`ProviderScope`, `FutureProvider.family`, `StateNotifierProvider`)
- **API Endpoint**: `https://corepunk.help/api/items/by-category`
- **CDN Host**: `https://d2fwno52vggyhx.cloudfront.net/`
- **Local Storage**: `shared_preferences` with 1500ms debounced disk writes (`StorageService`)

---

## 🗺️ Planning & Roadmap

All project planning, requirements, milestone tracking, and architecture decisions are maintained in the `.planning/` directory:

- 📋 **[PROJECT.md](file:///c:/Users/Drummond/Development/corepunk-flutter/.planning/PROJECT.md)**: Core project scope, tech stack, and user preferences.
- 🛣️ **[ROADMAP.md](file:///c:/Users/Drummond/Development/corepunk-flutter/.planning/ROADMAP.md)**: Milestones, completed phases, and future feature roadmap.
- 📊 **[STATE.md](file:///c:/Users/Drummond/Development/corepunk-flutter/.planning/STATE.md)**: Current system state, active branch tracking, and technical context.

Refer to `@.planning` whenever initiating new workstreams, reviewing completed features, or planning next steps.

---

## 📂 Codebase Architecture

```
lib/
├── main.dart                             # Entry point (ProviderScope + StorageService.init())
├── core/
│   ├── theme/
│   │   ├── app_colors.dart               # Corepunk Gold/Dark design tokens & rarity colors
│   │   └── app_theme.dart                # MaterialApp dark theme, surfaceTintColor reset
│   └── services/
│       └── storage_service.dart          # Debounced disk storage via SharedPreferences (1500ms)
├── features/
│   ├── navigation/
│   │   └── presentation/pages/
│   │       └── main_navigation_page.dart # Bottom navigation scaffold & screen routing
│   └── items/
│       ├── data/
│       │   ├── models/
│       │   │   ├── corepunk_item.dart        # Corepunk API defensive JSON parser
│       │   │   ├── corepunk_item_detail.dart # Detailed stats, recipes, & quality image URL generator
│       │   │   └── item_filters.dart        # Category, tier, quality, & search filter state
│       │   └── repositories/
│       │       └── items_repository.dart    # HTTP API client for Corepunk Help API
│       ├── providers/
│       │   ├── items_provider.dart            # TanStack Query-style Riverpod FutureProvider
│       │   └── ingredient_prices_provider.dart# Global crafting gold cost StateNotifierProvider
│       ├── services/
│       │   └── item_translation_service.dart  # Hybrid translation engine (Overrides -> Cache -> Google Translate)
│       └── presentation/
│           ├── pages/
│           │   └── items_page.dart            # Items grid, search bar debouncing, pull-to-refresh
│           └── widgets/
│               ├── header.dart                # Fixed dark AppBar (COREPUNK MOBILE)
│               ├── category_selector_widget.dart# Horizontal category filter chips
│               ├── item_filter_bar_widget.dart  # Search bar, dropdowns, reset filters button
│               ├── item_card_widget.dart        # Item card component with rarity border
│               └── item_detail/
│                   ├── item_detail_modal.dart   # Polymorphic bottom sheet modal
│                   ├── item_detail_header_widget.dart # Rarity gallery (0ms switch, border opacity)
│                   ├── item_stats_widget.dart   # Stats, Secondary Stats (chip slots), Lore
│                   ├── item_crafting_calculator_widget.dart # Recipe dropdown & Gold cost calculator
│                   └── item_skin_set_widget.dart# Complete Skin Set (5x4 grid based on upgradable flag)
```

---

## 🛠️ Key Architectural Patterns & Conventions

### 1. Hybrid Translation Engine (`ItemTranslationService`)
- Indexing key: `item.id.toString()` (shared across all 4 rarities for 0ms quality switches).
- Pipeline: Manual Overrides -> Memory Cache (`_memoryCache`) -> Local Disk Storage (`StorageService`) -> Free Google Translate API.
- RegEx replacement for game stat brackets (`[mcc]`, `[ap]`, `[wd]`, `[poison]`, `[cd]`).
- Manual refetch button `(G)` protected by a 5-second anti-spam cooldown.

### 2. Crafting Gold Cost Calculator (`ingredientPricesProvider`)
- Global `StateNotifierProvider` mapping `ingredientSlug` to `double` price.
- Live cost updates across all open item modals.
- Whole & decimal support (`12.5g`, `0,75g`) with clean `_formatGold` formatting.

### 3. Skin Set Logic (`ItemSkinSetWidget`)
- Uses API boolean **`upgradable`**:
  - `upgradable == false`: Standalone single skin item -> `CONJUNTO COMPLETO` section is **HIDDEN**.
  - `upgradable == true`: Upgradable armor set -> `CONJUNTO COMPLETO` section is **SHOWN**.
- CDN URL mapping for 5 body slots (`head`, `body`, `arms`, `legs`, `feet`) across 4 color variants (`grey`, `green`, `yellow`, `purple`).

---

## ⚠️ Strict Rules for AI Agents

1. **Always run `flutter analyze` after EVERY code change**:
   - Execute `C:\Users\Drummond\flutter\bin\flutter.bat analyze` via `run_command`.
   - Maintain 0 errors and 0 lint warnings at all times.

2. **No Automatic `git push`**:
   - Never run `git push` automatically without explicit user approval.
   - Perform all commits locally on dedicated feature branches (e.g., `feat/...`).

3. **No Inline Code Comments**:
   - Write clean, self-documenting Dart 3 code without inline `//` or `///` comments unless specifically instructed.
   - Explain technical details in chat responses.

4. **Preserve User Modifications**:
   - Respect user edits to files (e.g., `header.dart` title `'COREPUNK MOBILE'`).
