import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemDetailHeaderWidget extends StatelessWidget {
  final CorepunkItemDetail item;
  final String selectedQuality;
  final ValueChanged<String> onQualitySelected;

  const ItemDetailHeaderWidget({
    super.key,
    required this.item,
    required this.selectedQuality,
    required this.onQualitySelected,
  });

  static const List<Map<String, dynamic>> qualities = [
    {'id': 'common', 'label': 'Comum', 'color': AppColors.rarityCommon},
    {'id': 'uncommon', 'label': 'Incomum', 'color': AppColors.rarityUncommon},
    {'id': 'rare', 'label': 'Raro', 'color': AppColors.rarityRare},
    {'id': 'epic', 'label': 'Épico', 'color': AppColors.rarityEpic},
  ];

  Color _getRarityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'uncommon':
        return AppColors.rarityUncommon;
      case 'rare':
        return AppColors.rarityRare;
      case 'epic':
        return AppColors.rarityEpic;
      case 'common':
      default:
        return AppColors.rarityCommon;
    }
  }

  bool get _hasQualityVariations {
    final t = item.type.toLowerCase();
    return t == 'weapon' || t == 'implant' || t == 'chip' || t == 'rune';
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getRarityColor(selectedQuality);

    return Container(
      padding: const EdgeInsets.all(16.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.cardForeground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: activeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: activeColor),
                          ),
                          child: Text(
                            selectedQuality.toUpperCase(),
                            style: TextStyle(
                              color: activeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tier ${item.tier} • Nível ${item.level}',
                          style: const TextStyle(
                            color: AppColors.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.mutedForeground),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_hasQualityVariations)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: qualities.map((q) {
                final id = q['id'] as String;
                final color = q['color'] as Color;
                final isSelected = selectedQuality.toLowerCase() == id;
                final variantUrl = item.getImageUrlForQuality(id);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: InkWell(
                    onTap: () => onQualitySelected(id),
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? color : AppColors.border,
                          width: isSelected ? 2.5 : 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          variantUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.shield_outlined, color: color, size: 24);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: activeColor, width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.shield_outlined, color: activeColor, size: 32);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
