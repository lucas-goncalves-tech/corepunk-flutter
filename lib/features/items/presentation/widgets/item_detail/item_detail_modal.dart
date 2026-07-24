import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item.dart';
import '../../../data/models/corepunk_item_detail.dart';
import '../../../services/item_translation_service.dart';
import 'item_detail_header_widget.dart';
import 'item_stats_widget.dart';
import 'item_crafting_calculator_widget.dart';
import 'item_skin_set_widget.dart';

class ItemDetailModal extends StatefulWidget {
  final CorepunkItem itemSummary;

  const ItemDetailModal({super.key, required this.itemSummary});

  static Future<void> show(BuildContext context, CorepunkItem item) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ItemDetailModal(itemSummary: item),
    );
  }

  @override
  State<ItemDetailModal> createState() => _ItemDetailModalState();
}

class _ItemDetailModalState extends State<ItemDetailModal> {
  late String _selectedQuality;
  late Future<CorepunkItemDetail> _translationFuture;
  final ScrollController _scrollController = ScrollController();

  bool _isRefetchingTranslation = false;
  DateTime? _lastRefetchTime;

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.itemSummary.quality;
    _initTranslation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initTranslation({bool forceRefetch = false}) {
    final rawDetail = _buildRawDetail();
    _translationFuture = ItemTranslationService.translateItemDetail(
      rawDetail,
      forceRefetch: forceRefetch,
    );
  }

  void _onQualityChanged(String newQuality) {
    setState(() {
      _selectedQuality = newQuality;
    });
  }

  Future<void> _handleManualRefetchTranslation() async {
    if (_isRefetchingTranslation) return;

    if (_lastRefetchTime != null) {
      final elapsed = DateTime.now().difference(_lastRefetchTime!).inSeconds;
      if (elapsed < 5) {
        final remaining = 5 - elapsed;
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Aguarde'),
              content: Text(
                'Aguarde $remaining segundo(s) antes de traduzir novamente.',
              ),
              severity: InfoBarSeverity.warning,
              onClose: close,
            );
          },
          duration: const Duration(seconds: 2),
        );
        return;
      }
    }

    setState(() {
      _isRefetchingTranslation = true;
      _lastRefetchTime = DateTime.now();
      _initTranslation(forceRefetch: true);
    });

    try {
      await _translationFuture;
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isRefetchingTranslation = false;
      });
      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: const Text('Sucesso'),
            content: const Text('Tradução recarregada com sucesso!'),
            severity: InfoBarSeverity.success,
            onClose: close,
          );
        },
        duration: const Duration(seconds: 2),
      );
    }
  }

  CorepunkItemDetail _buildRawDetail() {
    final stats = <ItemStatInfo>[];
    if (widget.itemSummary.tags.contains('as')) {
      stats.add(const ItemStatInfo(id: 1, type: 'as', min: 0.7, max: 1.2));
    }
    if (widget.itemSummary.tags.contains('wd')) {
      stats.add(const ItemStatInfo(id: 2, type: 'wd', min: 8.3, max: 28.6));
    }
    if (widget.itemSummary.tags.contains('mpen')) {
      stats.add(const ItemStatInfo(id: 3, type: 'mpen', min: 5.0, max: 10.0));
    }
    if (widget.itemSummary.tags.contains('armor')) {
      stats.add(const ItemStatInfo(id: 4, type: 'armor', min: 30.0, max: 50.0));
    }
    if (widget.itemSummary.tags.contains('ap')) {
      stats.add(const ItemStatInfo(id: 5, type: 'ap', min: 20.0, max: 40.0));
    }

    List<IngredientItem> workbenchIngredients = [];
    if (widget.itemSummary.type == 'weapon') {
      workbenchIngredients = const [
        IngredientItem(
          id: 101,
          name: 'Receita de Armaria',
          quantity: 1,
          type: 'consumable',
          slug: 'recipe-weaponsmithing',
        ),
        IngredientItem(
          id: 102,
          name: 'Lingote Meteórico',
          quantity: 3,
          type: 'resource',
          slug: 'meteoric-ingot',
        ),
        IngredientItem(
          id: 103,
          name: 'Nugget de Titânio',
          quantity: 1,
          type: 'resource',
          slug: 'titanium-nugget',
        ),
        IngredientItem(
          id: 104,
          name: 'Casco Verde',
          quantity: 1,
          type: 'resource',
          slug: 'green-shell',
        ),
      ];
    } else if (widget.itemSummary.type == 'implant') {
      workbenchIngredients = const [
        IngredientItem(
          id: 201,
          name: 'Receita de Construção',
          quantity: 1,
          type: 'consumable',
          slug: 'recipe-construction',
        ),
        IngredientItem(
          id: 202,
          name: 'Mel de Sangue',
          quantity: 2,
          type: 'resource',
          slug: 'blood-honey',
        ),
        IngredientItem(
          id: 203,
          name: 'Líquido de Thermium',
          quantity: 1,
          type: 'resource',
          slug: 'thermium-liquidum',
        ),
      ];
    }

    final recipes = <CraftRecipeInfo>[];
    if (workbenchIngredients.isNotEmpty) {
      recipes.add(
        CraftRecipeInfo(
          name: 'Bancada (Workbench)',
          ingredients: workbenchIngredients,
        ),
      );

      recipes.add(
        CraftRecipeInfo(
          name: 'Melhorado (Upgraded)',
          ingredients: [
            ...workbenchIngredients.take(2),
            const IngredientItem(
              id: 301,
              name: 'Kit de Upgrade de Item',
              quantity: 1,
              type: 'resource',
              slug: 'adept-item-upgrade-kit-t1',
            ),
          ],
        ),
      );

      recipes.add(
        CraftRecipeInfo(
          name: 'Overclockado (Overclocked)',
          ingredients: [
            ...workbenchIngredients.take(2),
            const IngredientItem(
              id: 302,
              name: 'Kit de Upgrade de Mestre',
              quantity: 1,
              type: 'resource',
              slug: 'master-item-upgrade-kit-t2',
            ),
          ],
        ),
      );
    }

    return CorepunkItemDetail(
      id: widget.itemSummary.id,
      name: widget.itemSummary.name,
      slug: widget.itemSummary.slug,
      quality: _selectedQuality,
      type: widget.itemSummary.type,
      tier: widget.itemSummary.tier,
      level: widget.itemSummary.level,
      upgradable: widget.itemSummary.upgradable,
      profession: widget.itemSummary.profession,
      descriptionEffect: widget.itemSummary.descriptionEffect,
      description: widget.itemSummary.description,
      archetype: widget.itemSummary.archetype,
      sex: widget.itemSummary.sex,
      slot: widget.itemSummary.slot,
      stats: stats,
      workbenchIngredients: workbenchIngredients,
      synthesisRecipes: recipes,
      specialEffect:
          (widget.itemSummary.descriptionEffect != null &&
              widget.itemSummary.descriptionEffect!.isNotEmpty)
          ? SpecialEffectInfo(
              id: 99,
              title: 'Chance On-hit',
              descriptionEffect: widget.itemSummary.descriptionEffect!,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawDetail = _buildRawDetail();

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
      title: null,
      content: FutureBuilder<CorepunkItemDetail>(
        future: _translationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildGlassmorphismLoader();
          }

          final translatedBase = snapshot.data ?? rawDetail;
          final detail = CorepunkItemDetail(
            id: translatedBase.id,
            name: translatedBase.name,
            slug: translatedBase.slug,
            quality: _selectedQuality,
            type: translatedBase.type,
            tier: translatedBase.tier,
            level: translatedBase.level,
            upgradable: translatedBase.upgradable,
            profession: translatedBase.profession,
            professionLevel: translatedBase.professionLevel,
            description: translatedBase.description,
            descriptionEffect: translatedBase.descriptionEffect,
            archetype: translatedBase.archetype ?? widget.itemSummary.archetype,
            sex: translatedBase.sex ?? widget.itemSummary.sex,
            slot: translatedBase.slot ?? widget.itemSummary.slot,
            stats: translatedBase.stats,
            workbenchIngredients: translatedBase.workbenchIngredients,
            synthesisRecipes: translatedBase.synthesisRecipes,
            specialEffect: translatedBase.specialEffect,
          );

          return Column(
            children: [
              ItemDetailHeaderWidget(
                item: detail,
                selectedQuality: _selectedQuality,
                onQualitySelected: _onQualityChanged,
                onRefetchTranslation: _handleManualRefetchTranslation,
                isRefetching: _isRefetchingTranslation,
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16.0),
                  children: [
                    if (detail.type == 'skin') ItemSkinSetWidget(item: detail),
                    if (detail.type != 'skin' &&
                        (detail.stats.isNotEmpty ||
                            detail.specialEffect != null ||
                            (detail.description != null &&
                                detail.description!.isNotEmpty)))
                      ItemStatsWidget(item: detail),
                    if (detail.workbenchIngredients.isNotEmpty &&
                        detail.type != 'skin')
                      ItemCraftingCalculatorWidget(item: detail),
                    if (detail.profession != null &&
                        detail.profession!.isNotEmpty) ...[
                      Container(
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
                              'PROFISSÃO:',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Especialização: ${detail.profession!}',
                              style: const TextStyle(
                                color: AppColors.cardForeground,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        Button(
          child: const Text('Fechar'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildGlassmorphismLoader() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProgressRing(activeColor: AppColors.primary, strokeWidth: 3),
                SizedBox(height: 16),
                Text(
                  'Traduzindo dados do item...',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
