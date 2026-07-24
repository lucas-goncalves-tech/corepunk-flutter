import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/build_guide.dart';
import '../../data/models/build_filters.dart';

class BuildGuideCardWidget extends StatelessWidget {
  final BuildGuide buildGuide;
  final VoidCallback? onTap;

  const BuildGuideCardWidget({
    super.key,
    required this.buildGuide,
    this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String? _extractYoutubeId(String url) {
    if (url.isEmpty) return null;
    final RegExp regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  Future<void> _launchYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final youtubeId = _extractYoutubeId(buildGuide.youtubeLink);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppColors.borderRadius,
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (youtubeId != null) ...[
                GestureDetector(
                  onTap: () => _launchYoutube(buildGuide.youtubeLink),
                  child: ClipRRect(
                    borderRadius: AppColors.borderRadius,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Caso não tenha maxresdefault, faz fallback pra hqdefault
                            return Image.network(
                              'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg',
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        const Icon(
                          FluentIcons.play_solid,
                          color: Color(0xFFFF0000), // YouTube Red
                          size: 64,
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(FluentIcons.video, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Assistir',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      buildGuide.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.cardForeground,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    FluentIcons.contact,
                    size: 14,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    buildGuide.authorName,
                    style: const TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    FluentIcons.shield,
                    size: 14,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    buildGuide.masteryName.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (buildGuide.createdAt != null)
                    Text(
                      _formatDate(buildGuide.createdAt),
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              if (buildGuide.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: buildGuide.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Text(
                        BuildFilters.translateTag(tag),
                        style: const TextStyle(
                          color: AppColors.mutedForeground,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
