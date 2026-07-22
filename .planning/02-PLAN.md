# Phase 2.6 Plan: Item Detail Modal with Modular Body & Crafting Calculator

## Goal Description
Implement a polymorphic, modular Item Detail Bottom Sheet Modal (`ItemDetailModal`) that adapts its content based on item category and API data (Main Stats, Modifications, Crafting Calculator, Complete Skin Sets, Profession Requirements, Lore).

## User Review Required
> [!IMPORTANT]
> The Item Detail view uses a modular layout that dynamically shows/hides sections:
> - Weapons/Artifacts: Displays Main Stats, Modifications (+1/+2 slots), Special Effects, and Crafting Cost Calculator.
> - Skins: Displays Character, Slot, Color, and Complete Set grid.
> - Crafting Items: Displays Workbench/Synthesis Recipe Selector & Interactive Gold Cost Calculator.

## Open Questions
- None. Requirements aligned in chat.

## Proposed Changes

### Models & Data Layer
#### [NEW] [corepunk_item_detail.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/data/models/corepunk_item_detail.dart)
- Model representing detailed item specs, ingredients, craft recipes, skin sets, and special effects.

#### [MODIFY] [items_repository.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/data/repositories/items_repository.dart)
- Add `fetchItemDetail(String slug)` or `fetchItemDetailById(int id)` if needed, or expand parsing.

#### [MODIFY] [items_provider.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/providers/items_provider.dart)
- Add `itemDetailProvider` for fetching and caching full item details.

### Presentation Components
#### [NEW] [item_detail_header_widget.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/widgets/item_detail/item_detail_header_widget.dart)
- Top header with close button, item title, type badge, and interactive 4-rarity quality selector gallery.

#### [NEW] [item_stats_widget.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/widgets/item_detail/item_stats_widget.dart)
- Renders main stats (with CDN icons), chip modifications, and special effect text.

#### [NEW] [item_crafting_calculator_widget.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/widgets/item_detail/item_crafting_calculator_widget.dart)
- Recipe dropdown (Workbench, Upgraded, Overclocked), ingredient icons, interactive gold cost calculator table, quantity multiplier, and total gold calculation.

#### [NEW] [item_skin_set_widget.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/widgets/item_detail/item_skin_set_widget.dart)
- Renders skin metadata and 5x4 complete set grid for skins.

#### [NEW] [item_detail_modal.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/widgets/item_detail/item_detail_modal.dart)
- Main bottom sheet modal stitching together the header and dynamic modular body components.

#### [MODIFY] [items_page.dart](file:///c:/Users/Drummond/Development/corepunk-flutter/lib/features/items/presentation/pages/items_page.dart)
- Connect `ItemCardWidget` `onTap` to open `ItemDetailModal.show(context, item)`.

## Verification Plan
### Automated Tests
- Run `flutter analyze` after every single file creation/modification.

### Manual Verification
- Test opening a Weapon (*Acidsting*) in Android Emulator: verify rarity selector, stats, special effect, and Crafting Gold Calculator.
- Test opening a Skin (*Battering Ram*): verify complete set grid.
