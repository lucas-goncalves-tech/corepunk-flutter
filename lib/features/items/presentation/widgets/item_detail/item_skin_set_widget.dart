import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemSkinSetWidget extends StatelessWidget {
  final CorepunkItemDetail item;

  const ItemSkinSetWidget({
    super.key,
    required this.item,
  });

  static const List<Color> rarityColors = [
    AppColors.rarityCommon,
    AppColors.rarityUncommon,
    AppColors.rarityRare,
    AppColors.rarityEpic,
  ];

  static const List<String> setSlots = [
    'Helm',
    'Chest',
    'Gloves',
    'Pants',
    'Boots',
  ];

  @override
  Widget build(BuildContext context) {
    if (item.type.toLowerCase() != 'skin') {
      return const SizedBox.shrink();
    }

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
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.accessibility_new_rounded, size: 16, color: AppColors.mutedForeground),
              SizedBox(width: 6),
              Text('Personagem: ', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              Text('Campeão', style: TextStyle(color: AppColors.cardForeground, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.male_rounded, size: 16, color: AppColors.mutedForeground),
              SizedBox(width: 6),
              Text('Sexo: ', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              Text('Masculino', style: TextStyle(color: AppColors.cardForeground, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.checkroom_rounded, size: 16, color: AppColors.mutedForeground),
              SizedBox(width: 6),
              Text('Slot: ', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              Text('Peitoral (Chest)', style: TextStyle(color: AppColors.cardForeground, fontSize: 12, fontWeight: FontWeight.bold)),
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
            children: setSlots.map((slot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: rarityColors.map((color) {
                    return Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color, width: 2.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.checkroom_rounded, color: color, size: 24),
                        ),
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
