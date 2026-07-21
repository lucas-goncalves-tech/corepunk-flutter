# Roadmap: Corepunk Help Flutter

## Milestones

### Milestone 1: Environment Setup & Project Baseline
- [ ] Phase 1: Environment Setup & Dark Theme Scaffold (Status: In Progress)

### Milestone 2: Items Database UI (Micro-Steps)
- [ ] Phase 2: Top Header & App Bar Component
- [ ] Phase 3: Category Filter Bar Component
- [ ] Phase 4: Search Input & Filter Badges Component
- [ ] Phase 5: Item Card Component (Standalone Design)
- [ ] Phase 6: Item Grid Body & API Riverpod Integration
- [ ] Phase 7: Item Detail Modal / Sheet Component

### Milestone 3: App Navigation & Other Tabs
- [ ] Phase 8: Bottom Navigation Bar & Heroes/Guides/Map Tabs

---

## Phase Details

### Phase 1: Environment Setup & Dark Theme Scaffold
**Goal:** Setup Flutter SDK & Android Studio, initialize `corepunk_app`, configure Riverpod and Dark Fantasy theme tokens.
**Status:** In Progress
**Plans:**
- `01-PLAN.md` (Setup, Pubspec, AppTheme, Skeleton)

### Phase 2: Top Header & App Bar Component
**Goal:** Implement `CorepunkHeaderWidget` with logo, title and API connection indicator.

### Phase 3: Category Filter Bar Component
**Goal:** Implement `CategorySelectorWidget` with horizontal scroll and active category state.

### Phase 4: Search Input & Filter Badges Component
**Goal:** Implement `ItemSearchBarWidget` with debounce search and filter drawer button.

### Phase 5: Item Card Component
**Goal:** Implement standalone `ItemCardWidget` with rarity borders and tier indicators.

### Phase 6: Item Grid Body & API Riverpod Integration
**Goal:** Connect to `https://corepunk.help/api/items/by-category` using Riverpod, grid display, loading/error states.

### Phase 7: Item Detail Modal / Sheet Component
**Goal:** Implement item detail bottom sheet with full stats, craft requirements, and lore.

### Phase 8: Bottom Navigation Bar & Secondary Tabs
**Goal:** Implement global tab navigation (Items, Heroes, Guides, Map).
