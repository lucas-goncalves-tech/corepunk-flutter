import 'package:fluent_ui/fluent_ui.dart';
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
    {'id': '', 'label': 'Todas', 'icon': FluentIcons.shield},
    {'id': 'legionnary', 'label': 'Legionário', 'icon': FluentIcons.shield_solid},
    {'id': 'shaman', 'label': 'Xamã', 'icon': FluentIcons.heart},
    {'id': 'blast-medic', 'label': 'Médico de Expl.', 'icon': FluentIcons.medical},
    {'id': 'infiltrator', 'label': 'Infiltrador', 'icon': FluentIcons.hide},
    {'id': 'ranger', 'label': 'Patrulheiro', 'icon': FluentIcons.map_pin},
    {'id': 'destroyer', 'label': 'Destruidor', 'icon': FluentIcons.flame_solid},
    {'id': 'defender', 'label': 'Defensor', 'icon': FluentIcons.shield},
    {'id': 'champion', 'label': 'Campeão', 'icon': FluentIcons.medal},
    {'id': 'warmonger', 'label': 'Mestre da Guerra', 'icon': FluentIcons.user_sync},
    {'id': 'assassin', 'label': 'Assassino', 'icon': FluentIcons.lightning_bolt},
    {'id': 'sniper', 'label': 'Atirador', 'icon': FluentIcons.search},
    {'id': 'engineer', 'label': 'Engenheiro', 'icon': FluentIcons.developer_tools},
    {'id': 'bomber', 'label': 'Bomber', 'icon': FluentIcons.flame_solid},
    {'id': 'mercenary', 'label': 'Mercenário', 'icon': FluentIcons.money},
    {'id': 'commando', 'label': 'Comando', 'icon': FluentIcons.rocket},
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
                Tooltip(
                  message: 'Limpar Tags',
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onResetFilters,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.destructive.withValues(alpha: 0.15),
                          borderRadius: AppColors.borderRadius,
                          border: Border.all(color: AppColors.destructive),
                        ),
                        child: const Icon(FluentIcons.clear_filter, color: AppColors.destructive, size: 16),
                      ),
                    ),
                  ),
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showMultiSelectDialog(context),
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
                FluentIcons.chevron_down,
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                size: 14,
              ),
            ],
          ),
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
    return ContentDialog(
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
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _toggleTag(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(FluentIcons.check_mark, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        BuildFilters.translateTag(tag),
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: AppColors.mutedForeground)),
        ),
        FilledButton(
          onPressed: () {
            widget.onApply(_selectedTags);
            Navigator.of(context).pop();
          },
          child: const Text('Aplicar', style: TextStyle(fontWeight: FontWeight.bold)),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
