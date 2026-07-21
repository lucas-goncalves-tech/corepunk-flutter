import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategorySelectorWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {'id': '', 'label': 'Todos', 'icon': Icons.grid_view_rounded},
    {'id': 'weapon', 'label': 'Armas', 'icon': Icons.sports_kabaddi_rounded},
    {'id': 'artifact', 'label': 'Artefatos', 'icon': Icons.hexagon_outlined},
    {'id': 'chip', 'label': 'Chips', 'icon': Icons.memory_rounded},
    {'id': 'rune', 'label': 'Runas', 'icon': Icons.polyline_rounded},
    {'id': 'consumable', 'label': 'Consumíveis', 'icon': Icons.science_rounded},
    {'id': 'resource', 'label': 'Recursos', 'icon': Icons.inventory_2_outlined},
    {'id': 'talent', 'label': 'Talentos', 'icon': Icons.auto_awesome_rounded},
    {'id': 'skin', 'label': 'Skins', 'icon': Icons.checkroom_rounded},
    {'id': 'mount', 'label': 'Montarias', 'icon': Icons.pets_rounded},
    {'id': 'quest-item', 'label': 'Missões', 'icon': Icons.description_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['id'];

          return _CategoryChip(
            label: category['label'] as String,
            icon: category['icon'] as IconData,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category['id'] as String),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
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
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.card,
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
                color: isSelected
                    ? AppColors.primary
                    : AppColors.mutedForeground,
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
