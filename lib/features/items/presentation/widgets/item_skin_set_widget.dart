import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/corepunk_item_detail.dart';

class ItemSkinSetWidget extends StatelessWidget {
  final CorepunkItemDetail item;

  const ItemSkinSetWidget({
    super.key,
    required this.item,
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

  String _extractSetPrefix(String slug) {
    final clean = slug.replaceAll(RegExp(r'-(common|uncommon|rare|epic)$'), '');
    return clean.replaceAll(RegExp(r'-(head|body|hands|legs|feet|helmet|chest|gloves|pants|boots)$'), '');
  }

  String _getSkinImageUrl(String prefix, String slot, String quality) {
    final baseSlug = '$prefix-$slot';
    if (quality.toLowerCase() == 'common') {
      return 'https://d2fwno52vggyhx.cloudfront.net/items/skin/$baseSlug.png';
    }
    return 'https://d2fwno52vggyhx.cloudfront.net/items/skin/$baseSlug-${quality.toLowerCase()}.png';
  }

  @override
  Widget build(BuildContext context) {
    final prefix = _extractSetPrefix(item.slug);
    final qualities = const ['common', 'uncommon', 'rare', 'epic'];
    final slots = const ['head', 'body', 'hands', 'legs', 'feet'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppColors.borderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INFORMAÇÕES DA SKIN:',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.accessibility_new_rounded, size: 14, color: AppColors.mutedForeground),
              const SizedBox(width: 6),
              Text(
                'Personagem: ${item.archetype ?? "Campeão"}',
                style: const TextStyle(color: AppColors.cardForeground, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.mutedForeground),
              const SizedBox(width: 6),
              Text(
                'Sexo: ${item.sex ?? "Masculino"}',
                style: const TextStyle(color: AppColors.cardForeground, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.checkroom_rounded, size: 14, color: AppColors.mutedForeground),
              const SizedBox(width: 6),
              Text(
                'Slot: ${item.slot ?? "Peitoral (Chest)"}',
                style: const TextStyle(color: AppColors.cardForeground, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.border),
          const Text(
            'CONJUNTO COMPLETO (COMPLETE SET):',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: slots.map((slotName) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: qualities.map((q) {
                    final color = _getBorderColor(q);
                    final imgUrl = _getSkinImageUrl(prefix, slotName, q);

                    return Container(
                      width: 68,
                      height: 68,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color, width: 1.5),
                      ),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          final altSlot = (slotName == 'head')
                              ? 'helmet'
                              : (slotName == 'body')
                                  ? 'chest'
                                  : (slotName == 'hands')
                                      ? 'gloves'
                                      : (slotName == 'legs')
                                          ? 'pants'
                                          : 'boots';
                          final altImgUrl = _getSkinImageUrl(prefix, altSlot, q);

                          return Image.network(
                            altImgUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                item.getImageUrlForQuality(q),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.checkroom_rounded, size: 24, color: AppColors.mutedForeground),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
