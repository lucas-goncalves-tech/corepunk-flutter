import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemDetailHeaderWidget extends StatelessWidget {
  final CorepunkItemDetail item;
  final String selectedQuality;
  final ValueChanged<String> onQualitySelected;
  final VoidCallback? onRefetchTranslation;
  final bool isRefetching;

  const ItemDetailHeaderWidget({
    super.key,
    required this.item,
    required this.selectedQuality,
    required this.onQualitySelected,
    this.onRefetchTranslation,
    this.isRefetching = false,
  });

  Color _getBorderColor(String quality) {
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
    return t == 'weapon' || t == 'implant' || (t == 'skin' && item.upgradable);
  }

  @override
  Widget build(BuildContext context) {
    final qualities = const ['common', 'uncommon', 'rare', 'epic'];
    final activeBorderColor = _getBorderColor(selectedQuality);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.foreground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: activeBorderColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: activeBorderColor),
                          ),
                          child: Text(
                            selectedQuality.toUpperCase(),
                            style: TextStyle(
                              color: activeBorderColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
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
              if (onRefetchTranslation != null)
                isRefetching
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: ProgressRing(
                            strokeWidth: 2.0,
                            activeColor: AppColors.primary,
                          ),
                        ),
                      )
                    : Tooltip(
                        message: 'Recarregar Tradução',
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.locale_language,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: onRefetchTranslation,
                        ),
                      ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_hasQualityVariations)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: qualities.map((q) {
                final isSelected =
                    q.toLowerCase() == selectedQuality.toLowerCase();
                final baseRarityColor = _getBorderColor(q);

                final borderColor = isSelected
                    ? baseRarityColor
                    : baseRarityColor.withValues(alpha: 0.35);

                final borderWidth = isSelected ? 2.5 : 1.5;
                final imageOpacity = isSelected ? 1.0 : 0.35;

                return GestureDetector(
                  onTap: () => onQualitySelected(q),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(6),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? baseRarityColor.withValues(alpha: 0.12)
                          : AppColors.card.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                    child: Opacity(
                      opacity: imageOpacity,
                      child: Image.network(
                        item.getImageUrlForQuality(q),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              FluentIcons.error,
                              size: 28,
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(8),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: activeBorderColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: activeBorderColor, width: 2.0),
            ),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                FluentIcons.error,
                size: 36,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
      ],
    );
  }
}
