import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemSkinSetWidget extends StatelessWidget {
  final CorepunkItemDetail item;

  const ItemSkinSetWidget({
    super.key,
    required this.item,
  });

  static const List<String> _slugSlots = ['head', 'body', 'arms', 'belt', 'legs'];

  static const List<String> _qualities = ['common', 'uncommon', 'rare', 'epic'];

  static const Map<String, Color> _qualityColors = {
    'common': AppColors.rarityCommon,
    'uncommon': AppColors.rarityUncommon,
    'rare': AppColors.rarityRare,
    'epic': AppColors.rarityEpic,
  };

  ({String setBase, String currentSlot, String color})? _parseSlug() {
    final cleanSlug = item.slug.replaceAll(RegExp(r'-(common|uncommon|rare|epic)$'), '');
    for (final slot in _slugSlots) {
      final pattern = '-$slot-';
      final idx = cleanSlug.lastIndexOf(pattern);
      if (idx != -1) {
        return (
          setBase: cleanSlug.substring(0, idx),
          currentSlot: slot,
          color: cleanSlug.substring(idx + pattern.length),
        );
      }
    }
    return null;
  }

  String _skinImageUrl(String setBase, String slot, String color, String quality) {
    final baseSlug = '$setBase-$slot-$color';
    if (quality == 'common') {
      return 'https://d2fwno52vggyhx.cloudfront.net/items/skin/$baseSlug.png';
    }
    return 'https://d2fwno52vggyhx.cloudfront.net/items/skin/$baseSlug-$quality.png';
  }

  String _capitalize(String? value) {
    if (value == null || value.isEmpty) return 'Any';
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.border,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.type.toLowerCase() != 'skin') {
      return const SizedBox.shrink();
    }

    final parsed = _parseSlug();

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
          _buildInfoRow(FluentIcons.contact, 'Personagem', _capitalize(item.archetype)),
          _buildInfoRow(FluentIcons.personalize, 'Sexo', _capitalize(item.sex)),
          _buildInfoRow(FluentIcons.shirt, 'Slot', _capitalize(item.slot)),
          if (parsed != null)
            _buildInfoRow(FluentIcons.color, 'Cor', _capitalize(parsed.color)),
          if (item.upgradable && parsed != null) ...[
            _buildDivider(),
            _buildCompleteSetGrid(parsed.setBase, parsed.currentSlot, parsed.color),
          ],
          if (item.description != null && item.description!.isNotEmpty) ...[
            _buildDivider(),
            Text(
              item.description!,
              style: const TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mutedForeground),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.cardForeground,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteSetGrid(String setBase, String currentSlot, String color) {
    final currentQuality = item.quality.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONJUNTO COMPLETO:',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ..._slugSlots.map((slot) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: _qualities.map((quality) {
                final imageUrl = _skinImageUrl(setBase, slot, color, quality);
                final isCurrentItem = slot == currentSlot && quality == currentQuality;
                final borderColor = _qualityColors[quality] ?? AppColors.rarityCommon;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Opacity(
                        opacity: isCurrentItem ? 0.45 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor, width: 2.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(FluentIcons.shirt, color: borderColor, size: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
