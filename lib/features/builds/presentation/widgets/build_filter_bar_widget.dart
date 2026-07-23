import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/build_filters.dart';

class BuildFilterBarWidget extends StatelessWidget {
  final BuildFilters currentFilters;
  final ValueChanged<String> onMasteryChanged;
  final ValueChanged<List<String>> onTagsChanged;
  final VoidCallback onResetFilters;

  const BuildFilterBarWidget({
    super.key,
    required this.currentFilters,
    required this.onMasteryChanged,
    required this.onTagsChanged,
    required this.onResetFilters,
  });

  static const List<Map<String, dynamic>> masteries = [
    {'id': '', 'label': 'Todas', 'icon': Icons.shield_outlined},
    {'id': 'legionnary', 'label': 'Legionário', 'icon': Icons.security_rounded},
    {'id': 'shaman', 'label': 'Xamã', 'icon': Icons.spa_rounded},
    {'id': 'blast-medic', 'label': 'Médico de Expl.', 'icon': Icons.medical_services_rounded},
    {'id': 'infiltrator', 'label': 'Infiltrador', 'icon': Icons.visibility_off_rounded},
    {'id': 'ranger', 'label': 'Patrulheiro', 'icon': Icons.my_location_rounded},
    {'id': 'destroyer', 'label': 'Destruidor', 'icon': Icons.local_fire_department_rounded},
    {'id': 'defender', 'label': 'Defensor', 'icon': Icons.shield_rounded},
    {'id': 'champion', 'label': 'Campeão', 'icon': Icons.military_tech_rounded},
    {'id': 'warmonger', 'label': 'Mestre da Guerra', 'icon': Icons.sports_martial_arts_rounded},
    {'id': 'assassin', 'label': 'Assassino', 'icon': Icons.flash_on_rounded},
    {'id': 'sniper', 'label': 'Atirador', 'icon': Icons.gps_fixed_rounded},
    {'id': 'engineer', 'label': 'Engenheiro', 'icon': Icons.engineering_rounded},
    {'id': 'bomber', 'label': 'Bomber', 'icon': Icons.whatshot_rounded},
    {'id': 'mercenary', 'label': 'Mercenário', 'icon': Icons.monetization_on_rounded},
    {'id': 'commando', 'label': 'Comando', 'icon': Icons.rocket_launch_rounded},
  ];

  static const List<String> availableTags = [
    'PvE', 'PvP', 'Tank', 'Healer', 'Support', 'Damage', 'Boss Killer', 'Mobs farmer', 'Open World', 'Arena', 'Battleground'
  ];

  bool get hasActiveFilters => currentFilters.tags.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Categorias de Mastery (Primeira linha com Scroll)
        Container(
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1.0),
            ),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: masteries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8.0),
            itemBuilder: (context, index) {
              final mastery = masteries[index];
              final isSelected = currentFilters.mastery == mastery['id'];

              return _MasteryChip(
                label: mastery['label'] as String,
                icon: mastery['icon'] as IconData,
                isSelected: isSelected,
                onTap: () => onMasteryChanged(mastery['id'] as String),
              );
            },
          ),
        ),

        // Dropdown Multi-select para Tags e Botão Limpar (Segunda linha)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: const BoxDecoration(
            color: AppColors.card,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1.0),
            ),
          ),
          child: Row(
            children: [
              _MultiSelectTagsButton(
                selectedTags: currentFilters.tags,
                onTagsChanged: onTagsChanged,
              ),
              const Spacer(),
              if (hasActiveFilters)
                IconButton(
                  tooltip: 'Limpar Tags',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.destructive.withValues(alpha: 0.15),
                    side: const BorderSide(color: AppColors.destructive),
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(0, 0),
                  ),
                  icon: const Icon(Icons.filter_alt_off_rounded, color: AppColors.destructive, size: 18),
                  onPressed: onResetFilters,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MultiSelectTagsButton extends StatelessWidget {
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const _MultiSelectTagsButton({
    required this.selectedTags,
    required this.onTagsChanged,
  });

  void _showMultiSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _MultiSelectDialog(
          initialSelectedTags: selectedTags,
          onApply: onTagsChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedTags.isNotEmpty;
    final label = isSelected ? '${selectedTags.length} Selecionadas' : 'Tags: Todas';

    return InkWell(
      onTap: () => _showMultiSelectDialog(context),
      borderRadius: AppColors.borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: AppColors.borderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: isSelected ? AppColors.primary : AppColors.mutedForeground,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final List<String> initialSelectedTags;
  final ValueChanged<List<String>> onApply;

  const _MultiSelectDialog({
    required this.initialSelectedTags,
    required this.onApply,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.initialSelectedTags);
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Selecionar Tags',
        style: TextStyle(color: AppColors.cardForeground, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BuildFilterBarWidget.availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(BuildFilters.translateTag(tag)),
              selected: isSelected,
              onSelected: (_) => _toggleTag(tag),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.background,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: AppColors.mutedForeground)),
        ),
        TextButton(
          onPressed: () {
            widget.onApply(_selectedTags);
            Navigator.of(context).pop();
          },
          child: const Text('Aplicar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _MasteryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MasteryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppColors.borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.card,
          borderRadius: AppColors.borderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppColors.primary : AppColors.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
