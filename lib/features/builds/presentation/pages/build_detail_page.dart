import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/build_guide.dart';
import '../../data/models/build_filters.dart';

class BuildDetailPage extends StatelessWidget {
  final BuildGuide buildGuide;

  const BuildDetailPage({super.key, required this.buildGuide});

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

  Widget _buildSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Text(
              content,
              style: const TextStyle(
                color: AppColors.cardForeground,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProsConsSection(String pros, String cons) {
    if (pros.isEmpty && cons.isEmpty) return const SizedBox.shrink();

    final prosList = pros
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final consList = cons
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho PROS & CONS
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'PROS & CONS',
                style: TextStyle(
                  color: AppColors.cardForeground,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily:
                      'Roboto', // Pode ser substituída pela fonte oficial do corepunk
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Advantages
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VANTAGENS',
                          style: TextStyle(
                            color: AppColors.cardForeground,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...prosList.map(
                          (pro) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              pro,
                              style: const TextStyle(
                                color: AppColors.rarityUncommon, // Verde
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Weak Spots
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PONTOS FRACOS',
                          style: TextStyle(
                            color: AppColors.cardForeground,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...consList.map(
                          (con) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              con,
                              style: const TextStyle(
                                color: AppColors.destructive, // Vermelho
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final youtubeId = _extractYoutubeId(buildGuide.youtubeLink);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.cardForeground),
        title: const Text(
          'Detalhes da Build',
          style: TextStyle(
            color: AppColors.cardForeground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da Build (Estilo Oficial)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Stack(
                children: [
                  // Imagem de Fundo da Mastery (Faded)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.transparent, Colors.black],
                            stops: [0.0, 0.4],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.network(
                            'https://d2fwno52vggyhx.cloudfront.net/heroes/${buildGuide.masteryName.toLowerCase().replaceAll(' ', '-')}-cover.jpg',
                            fit: BoxFit.cover,
                            width: 300,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback para typo da CDN 'legionnary' caso a string venha como 'legionary'
                              if (buildGuide.masteryName.toLowerCase() ==
                                  'legionary') {
                                return Image.network(
                                  'https://d2fwno52vggyhx.cloudfront.net/heroes/legionnary-cover.jpg',
                                  fit: BoxFit.cover,
                                  width: 300,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox(width: 300),
                                );
                              }
                              return const SizedBox(width: 300);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Conteúdo do Cabeçalho
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Ícone da Mastery
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.muted,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://d2fwno52vggyhx.cloudfront.net/masteries/characters/${buildGuide.masteryName.toLowerCase().replaceAll(' ', '-')}.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback para typo da CDN 'legionnary'
                                    if (buildGuide.masteryName.toLowerCase() ==
                                        'legionary') {
                                      return Image.network(
                                        'https://d2fwno52vggyhx.cloudfront.net/masteries/characters/legionnary.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.shield_outlined,
                                                  color:
                                                      AppColors.mutedForeground,
                                                ),
                                      );
                                    }
                                    return const Icon(
                                      Icons.shield_outlined,
                                      color: AppColors.mutedForeground,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Título e Autor
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    buildGuide.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.cardForeground,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      fontFamily:
                                          'Roboto', // Substituir por fonte customizada depois
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        'By: ',
                                        style: TextStyle(
                                          color: AppColors.mutedForeground,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        buildGuide.authorName,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '  •  Last updated on: ',
                                        style: TextStyle(
                                          color: AppColors.mutedForeground,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(buildGuide.createdAt),
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Tags no estilo Corepunk App
                        if (buildGuide.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: buildGuide.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.muted,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  BuildFilters.translateTag(tag),
                                  style: const TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Video Banner
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
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      const Icon(
                        Icons.play_circle_fill,
                        color: Color(0xFFFF0000),
                        size: 72,
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.ondemand_video_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Assistir no YouTube',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Seções de Texto
            _buildSection('Descrição', buildGuide.description),
            _buildSection('Gameplay', buildGuide.gameplay),

            // Pros e Cons integrados no visual oficial
            _buildProsConsSection(buildGuide.pros, buildGuide.cons),
          ],
        ),
      ),
    );
  }
}
