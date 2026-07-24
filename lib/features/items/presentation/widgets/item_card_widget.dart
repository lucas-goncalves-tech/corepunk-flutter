import 'package:fluent_ui/fluent_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/corepunk_item.dart';

class ItemCardWidget extends StatelessWidget {
  final CorepunkItem item;
  final VoidCallback? onTap;

  const ItemCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

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

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return 'Arma';
      case 'implant':
      case 'artifact':
        return 'Artefato';
      case 'chip':
        return 'Chip';
      case 'rune':
        return 'Runa';
      case 'consumable':
        return 'Consumível';
      case 'resource':
        return 'Recurso';
      case 'talent':
        return 'Talento';
      case 'skin':
        return 'Skin';
      case 'mount':
        return 'Montaria';
      case 'quest-item':
        return 'Item de Missão';
      default:
        return type.toUpperCase();
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return FluentIcons.shield;
      case 'implant':
      case 'artifact':
        return FluentIcons.diamond_solid;
      case 'chip':
        return FluentIcons.developer_tools;
      case 'rune':
        return FluentIcons.color;
      case 'consumable':
        return FluentIcons.heart;
      case 'resource':
        return FluentIcons.archive;
      case 'talent':
        return FluentIcons.starburst;
      case 'skin':
        return FluentIcons.shirt;
      case 'mount':
        return FluentIcons.car;
      case 'quest-item':
        return FluentIcons.clipboard_list;
      default:
        return FluentIcons.shield;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(item.quality);
    final typeLabel = _getTypeLabel(item.type);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppColors.borderRadius,
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: rarityColor, width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _getTypeIcon(item.type),
                        color: rarityColor,
                        size: 22,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.cardForeground,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      typeLabel,
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tier ${item.tier}',
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.tags.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: item.tags.take(3).map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Image.network(
                        'https://d2fwno52vggyhx.cloudfront.net/stats/$tag.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
