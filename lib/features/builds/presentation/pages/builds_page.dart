import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/build_guide_card_widget.dart';
import '../widgets/build_filter_bar_widget.dart';
import '../../providers/build_guides_provider.dart';
import '../../data/models/build_filters.dart';
import 'build_detail_page.dart';

class BuildsPage extends ConsumerStatefulWidget {
  const BuildsPage({super.key});

  @override
  ConsumerState<BuildsPage> createState() => _BuildsPageState();
}

class _BuildsPageState extends ConsumerState<BuildsPage> {
  final ScrollController _scrollController = ScrollController();
  
  BuildFilters _currentFilters = const BuildFilters();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onMasteryChanged(String mastery) {
    setState(() {
      _currentFilters = _currentFilters.copyWith(mastery: mastery);
    });
    // Voltar para o topo ao trocar o filtro
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onTagsChanged(List<String> tags) {
    setState(() {
      _currentFilters = _currentFilters.copyWith(tags: tags);
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onResetFilters() {
    setState(() {
      _currentFilters = _currentFilters.copyWith(tags: []);
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buildsState = ref.watch(buildGuidesProvider(_currentFilters));

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.card,
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
            ),
            child: const Row(
              children: [
                Icon(FluentIcons.library, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Text(
                  'COMMUNITY BUILDS',
                  style: TextStyle(
                    color: AppColors.cardForeground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          // Filters
          BuildFilterBarWidget(
            currentFilters: _currentFilters,
            onMasteryChanged: _onMasteryChanged,
            onTagsChanged: _onTagsChanged,
            onResetFilters: _onResetFilters,
          ),
          
          // List Body
          Expanded(
            child: buildsState.when(
              data: (state) {
                if (state.builds.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma build encontrada com estes filtros.',
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.builds.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.builds.length) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(buildGuidesProvider(_currentFilters).notifier).fetchNextPage();
                      });
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: ProgressRing(),
                        ),
                      );
                    }

                    final build = state.builds[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: BuildGuideCardWidget(
                        buildGuide: build,
                        onTap: () {
                          Navigator.push(
                            context,
                            FluentPageRoute(
                              builder: (context) => BuildDetailPage(buildGuide: build),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: ProgressRing(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Erro ao carregar builds.\n$error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
