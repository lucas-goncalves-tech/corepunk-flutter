import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/item_filters.dart';
import '../../providers/items_provider.dart';
import '../widgets/header.dart';
import '../widgets/category_selector_widget.dart';
import '../widgets/item_filter_bar_widget.dart';
import '../widgets/item_card_widget.dart';
import '../widgets/item_detail/item_detail_modal.dart';

class ItemsPage extends ConsumerStatefulWidget {
  const ItemsPage({super.key});

  @override
  ConsumerState<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends ConsumerState<ItemsPage> {
  ItemFilters _filters = const ItemFilters();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchControllerChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(itemsProvider(_filters).notifier).fetchNextPage();
    }
  }

  void _onSearchControllerChanged() {
    setState(() {});
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _filters = _filters.copyWith(
            name: query,
            type: query.isNotEmpty ? '' : _filters.type,
            page: 1,
          );
        });
      }
    });
  }

  void _resetFilters() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() {
      _filters = const ItemFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(itemsProvider(_filters));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: const HeaderWidget(),
        body: Column(
          children: [
            CategorySelectorWidget(
              selectedCategory: _filters.type,
              onCategorySelected: (type) {
                _searchDebounce?.cancel();
                setState(() {
                  _filters = _filters.copyWith(type: type, page: 1);
                });
              },
            ),
            ItemFilterBarWidget(
              searchController: _searchController,
              itemType: _filters.type,
              selectedQuality: _filters.quality,
              selectedTier: _filters.tier,
              selectedProfession: _filters.profession,
              selectedMastery: _filters.mastery,
              selectedArchetype: _filters.archetype,
              selectedSex: _filters.sex,
              selectedSlot: _filters.slot,
              onSearchChanged: _onSearchChanged,
              onQualityChanged: (quality) => setState(() => _filters = _filters.copyWith(quality: quality, page: 1)),
              onTierChanged: (tier) => setState(() => _filters = _filters.copyWith(tier: tier, page: 1)),
              onProfessionChanged: (prof) => setState(() => _filters = _filters.copyWith(profession: prof, page: 1)),
              onMasteryChanged: (mastery) => setState(() => _filters = _filters.copyWith(mastery: mastery, page: 1)),
              onArchetypeChanged: (arch) => setState(() => _filters = _filters.copyWith(archetype: arch, page: 1)),
              onSexChanged: (sex) => setState(() => _filters = _filters.copyWith(sex: sex, page: 1)),
              onSlotChanged: (slot) => setState(() => _filters = _filters.copyWith(slot: slot, page: 1)),
              onResetFilters: _resetFilters,
            ),
            Expanded(
              child: asyncState.when(
                data: (state) {
                  final items = state.items;
                  if (items.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.card,
                      onRefresh: () async {
                        ref.invalidate(itemsProvider(_filters));
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_rounded,
                                  size: 48,
                                  color: AppColors.mutedForeground,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Nenhum item encontrado com esses filtros.',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Puxe para baixo para atualizar',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.card,
                    onRefresh: () async {
                      ref.invalidate(itemsProvider(_filters));
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: items.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          );
                        }
                        
                        final item = items[index];
                        return ItemCardWidget(
                          item: item,
                          onTap: () {
                            ItemDetailModal.show(context, item);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 44,
                          color: AppColors.destructive,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Erro ao conectar com a API do Corepunk.',
                          style: TextStyle(
                            color: AppColors.destructive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => ref.invalidate(itemsProvider(_filters)),
                          child: const Text(
                            'Recarregar (F5)',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
