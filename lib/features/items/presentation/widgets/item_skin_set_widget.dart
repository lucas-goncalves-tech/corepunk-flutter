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

  String _formatSlot(String? rawSlot) {
    if (rawSlot == null || rawSlot.isEmpty) return 'Peça de Armadura';
    switch (rawSlot.toLowerCase()) {
      case 'helmet':
      case 'head':
        return 'Capacete (Head)';
      case 'body':
      case 'chest':
        return 'Peitoral (Chest)';
      case 'hands':
      case 'gloves':
        return 'Manoplas (Hands)';
      case 'legs':
      case 'pants':
        return 'Pernas (Legs)';
      case 'feet':
      case 'boots':
        return 'Botas (Feet)';
      default:
        return rawSlot;
    }
  }

  String _formatArchetype(String? raw) {
    if (raw == null || raw.isEmpty || raw.toLowerCase() == 'any') return 'Todos os Campeões';
    switch (raw.toLowerCase()) {
      case 'champion':
        return 'Campeão';
      case 'warmonger':
        return 'Belicista';
      case 'bomber':
        return 'Bombardeiro';
      case 'ranger':
        return 'Patrulheiro';
      case 'defender':
        return 'Defensor';
      default:
        return raw;
    }
  }

  String _formatSex(String? raw) {
    if (raw == null || raw.isEmpty || raw.toLowerCase() == 'any') return 'Ambos (Unissex)';
    switch (raw.toLowerCase()) {
      case 'male':
        return 'Masculino';
      case 'female':
        return 'Feminino';
      default:
        return raw;
    }
  }

  String _getSkinSlotUrl(String slug, String targetSlot) {
    String cleanSlug = slug;
    final currentSlotRegExp = RegExp(r'-(head|body|hands|legs|feet|helmet|chest|gloves|pants|boots)');

    if (currentSlotRegExp.hasMatch(cleanSlug)) {
      cleanSlug = cleanSlug.replaceAll(currentSlotRegExp, '-$targetSlot');
    } else {
      cleanSlug = '$cleanSlug-$targetSlot';
    }

    return 'https://d2fwno52vggyhx.cloudfront.net/items/skin/$cleanSlug.png';
  }

  @override
  Widget build(BuildContext context) {
    final qualities = const ['common', 'uncommon', 'rare', 'epic'];
    final slots = const ['head', 'body', 'hands', 'legs', 'feet'];
    final currentSlot = item.slot?.toLowerCase() ?? 'body';

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
                'Personagem: ${_formatArchetype(item.archetype)}',
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
                'Sexo: ${_formatSex(item.sex)}',
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
                'Slot: ${_formatSlot(item.slot)}',
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
              final isCurrentSlotRow = (currentSlot == slotName ||
                  (slotName == 'body' && currentSlot == 'chest') ||
                  (slotName == 'head' && currentSlot == 'helmet') ||
                  (slotName == 'hands' && currentSlot == 'gloves') ||
                  (slotName == 'legs' && currentSlot == 'pants') ||
                  (slotName == 'feet' && currentSlot == 'boots'));

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: qualities.map((q) {
                    final color = _getBorderColor(q);

                    String imgUrl;
                    if (isCurrentSlotRow && q == item.quality.toLowerCase()) {
                      imgUrl = item.imageUrl;
                    } else {
                      imgUrl = _getSkinSlotUrl(item.slug, slotName);
                    }

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
                          final altSlotName = (slotName == 'head')
                              ? 'helmet'
                              : (slotName == 'body')
                                  ? 'chest'
                                  : (slotName == 'hands')
                                      ? 'gloves'
                                      : (slotName == 'legs')
                                          ? 'pants'
                                          : 'boots';
                          final altUrl = _getSkinSlotUrl(item.slug, altSlotName);

                          return Image.network(
                            altUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.shield_outlined,
                                  size: 18,
                                  color: AppColors.border,
                                ),
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
