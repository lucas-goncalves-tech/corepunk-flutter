import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemStatsWidget extends StatelessWidget {
  final CorepunkItemDetail item;

  const ItemStatsWidget({
    super.key,
    required this.item,
  });

  String _getStatLabel(String type) {
    switch (type.toLowerCase()) {
      case 'as':
        return 'Velocidade de Ataque';
      case 'wd':
        return 'Dano de Arma';
      case 'mpen':
        return 'Penetração Mágica';
      case 'armor':
        return 'Armadura';
      case 'ap':
        return 'Poder de Ataque';
      case 'sp':
        return 'Poder Mágico';
      case 'hp':
        return 'Vida Máxima';
      case 'mp':
        return 'Mana Máxima';
      case 'mdr':
        return 'Resistência Mágica';
      default:
        return type.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (item.stats.isNotEmpty) ...[
            const Text(
              'ATRIBUTOS PRINCIPAIS:',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            ...item.stats.map((stat) {
              final label = _getStatLabel(stat.type);
              final valStr = (stat.min == stat.max)
                  ? '${stat.min}'
                  : '[${stat.min} - ${stat.max}]';

              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    Image.network(
                      'https://d2fwno52vggyhx.cloudfront.net/stats/${stat.type}.png',
                      width: 16,
                      height: 16,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$valStr ',
                      style: const TextStyle(
                        color: AppColors.cardForeground,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 20, color: AppColors.border),
          ],
          const Text(
            'MODIFICAÇÕES:',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '• Upgraded: +1 slot de chip básico adicional.',
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
          const SizedBox(height: 2),
          const Text(
            '• Overclocked: +2 slots de chip básicos adicionais.',
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
          if (item.specialEffect != null) ...[
            const Divider(height: 20, color: AppColors.border),
            Text(
              'EFEITO ESPECIAL: ${item.specialEffect!.title.toUpperCase()}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.specialEffect!.descriptionEffect.replaceAll('<br>', '\n'),
              style: const TextStyle(
                color: AppColors.cardForeground,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
