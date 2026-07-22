import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ItemFilterBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String itemType;
  final String selectedQuality;
  final String selectedTier;
  final String selectedProfession;
  final String selectedMastery;
  final String selectedArchetype;
  final String selectedSex;
  final String selectedSlot;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onQualityChanged;
  final ValueChanged<String> onTierChanged;
  final ValueChanged<String> onProfessionChanged;
  final ValueChanged<String> onMasteryChanged;
  final ValueChanged<String> onArchetypeChanged;
  final ValueChanged<String> onSexChanged;
  final ValueChanged<String> onSlotChanged;
  final VoidCallback onResetFilters;

  const ItemFilterBarWidget({
    super.key,
    required this.searchController,
    required this.itemType,
    required this.selectedQuality,
    required this.selectedTier,
    required this.selectedProfession,
    required this.selectedMastery,
    required this.selectedArchetype,
    required this.selectedSex,
    required this.selectedSlot,
    required this.onSearchChanged,
    required this.onQualityChanged,
    required this.onTierChanged,
    required this.onProfessionChanged,
    required this.onMasteryChanged,
    required this.onArchetypeChanged,
    required this.onSexChanged,
    required this.onSlotChanged,
    required this.onResetFilters,
  });

  static const List<Map<String, String>> qualities = [
    {'id': '', 'label': 'Qualidade: Todas'},
    {'id': 'common', 'label': 'Comum'},
    {'id': 'uncommon', 'label': 'Incomum'},
    {'id': 'rare', 'label': 'Raro'},
    {'id': 'epic', 'label': 'Épico'},
  ];

  static const List<Map<String, String>> tiers = [
    {'id': '', 'label': 'Tier: Todos'},
    {'id': '1', 'label': 'Tier 1'},
    {'id': '2', 'label': 'Tier 2'},
    {'id': '3', 'label': 'Tier 3'},
  ];

  static const List<Map<String, String>> professions = [
    {'id': '', 'label': 'Profissão: Todas'},
    {'id': 'mining', 'label': 'Mineração'},
    {'id': 'logging', 'label': 'Corte de Madeira'},
    {'id': 'butchery', 'label': 'Açougue'},
    {'id': 'herbalism', 'label': 'Herbologia'},
    {'id': 'construction', 'label': 'Construção'},
    {'id': 'weaponsmithing', 'label': 'Armaria'},
    {'id': 'mysticism', 'label': 'Misticismo'},
    {'id': 'alchemy', 'label': 'Alquimia'},
    {'id': 'cooking', 'label': 'Culinária'},
  ];

  static const List<Map<String, String>> masteries = [
    {'id': '', 'label': 'Classe: Todas'},
    {'id': 'legionnary', 'label': 'Legionário'},
    {'id': 'shaman', 'label': 'Xamã'},
    {'id': 'blast-medic', 'label': 'Médico de Explosão'},
    {'id': 'infiltrator', 'label': 'Infiltrador'},
    {'id': 'ranger', 'label': 'Patrulheiro'},
    {'id': 'destroyer', 'label': 'Destruidor'},
    {'id': 'defender', 'label': 'Defensor'},
  ];

  static const List<Map<String, String>> archetypes = [
    {'id': '', 'label': 'Personagem: Qualquer'},
    {'id': 'bomber', 'label': 'Bomber'},
    {'id': 'champion', 'label': 'Champion'},
    {'id': 'warmonger', 'label': 'Warmonger'},
  ];

  static const List<Map<String, String>> sexes = [
    {'id': '', 'label': 'Sexo: Qualquer'},
    {'id': 'male', 'label': 'Masculino'},
    {'id': 'female', 'label': 'Feminino'},
  ];

  static const List<Map<String, String>> slots = [
    {'id': '', 'label': 'Slot: Qualquer'},
    {'id': 'helmet', 'label': 'Capacete'},
    {'id': 'chest', 'label': 'Peito'},
    {'id': 'gloves', 'label': 'Luvas'},
    {'id': 'pants', 'label': 'Calças'},
    {'id': 'boots', 'label': 'Botas'},
    {'id': 'body', 'label': 'Corpo'},
  ];

  bool get hasActiveFilters =>
      searchController.text.isNotEmpty ||
      selectedQuality.isNotEmpty ||
      selectedTier.isNotEmpty ||
      selectedProfession.isNotEmpty ||
      selectedMastery.isNotEmpty ||
      selectedArchetype.isNotEmpty ||
      selectedSex.isNotEmpty ||
      selectedSlot.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isSkin = itemType.toLowerCase() == 'skin';

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: const TextStyle(color: AppColors.cardForeground, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar item por nome...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mutedForeground, size: 18),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.mutedForeground),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Limpar Filtros',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.destructive.withValues(alpha: 0.15),
                    side: const BorderSide(color: AppColors.destructive),
                  ),
                  icon: const Icon(Icons.filter_alt_off_rounded, color: AppColors.destructive, size: 18),
                  onPressed: onResetFilters,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (!isSkin) ...[
                  _buildFilterDropdown(
                    value: selectedQuality,
                    items: qualities,
                    onChanged: onQualityChanged,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    value: selectedTier,
                    items: tiers,
                    onChanged: onTierChanged,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    value: selectedProfession,
                    items: professions,
                    onChanged: onProfessionChanged,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    value: selectedMastery,
                    items: masteries,
                    onChanged: onMasteryChanged,
                  ),
                ] else ...[
                  _buildFilterDropdown(
                    value: selectedArchetype,
                    items: archetypes,
                    onChanged: onArchetypeChanged,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    value: selectedSex,
                    items: sexes,
                    onChanged: onSexChanged,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    value: selectedSlot,
                    items: slots,
                    onChanged: onSlotChanged,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.background,
        borderRadius: AppColors.borderRadius,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          dropdownColor: AppColors.popover,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.mutedForeground,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: isSelected ? AppColors.primary : AppColors.mutedForeground,
            size: 18,
          ),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'],
              child: Text(item['label']!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
