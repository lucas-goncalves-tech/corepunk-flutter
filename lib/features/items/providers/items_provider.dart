import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/corepunk_item.dart';
import '../data/models/item_filters.dart';
import '../data/repositories/items_repository.dart';

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository();
});

class ItemsState {
  final List<CorepunkItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  ItemsState({
    required this.items,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ItemsState copyWith({
    List<CorepunkItem>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ItemsState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ItemsNotifier extends FamilyAsyncNotifier<ItemsState, ItemFilters> {
  @override
  FutureOr<ItemsState> build(ItemFilters arg) async {
    final repository = ref.watch(itemsRepositoryProvider);
    // Always start at page 1 for a new filter state
    final filters = arg.copyWith(page: 1);
    final items = await repository.fetchItems(filters);
    return ItemsState(
      items: items,
      hasMore: items.length >= filters.size,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasError) return;
    
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final repository = ref.read(itemsRepositoryProvider);
      final nextPage = (currentState.items.length ~/ arg.size) + 1;
      final filters = arg.copyWith(page: nextPage);
      
      final newItems = await repository.fetchItems(filters);
      
      state = AsyncValue.data(
        currentState.copyWith(
          items: [...currentState.items, ...newItems],
          hasMore: newItems.length >= arg.size,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Revert loading more state on error
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final itemsProvider = AsyncNotifierProviderFamily<ItemsNotifier, ItemsState, ItemFilters>(
  ItemsNotifier.new,
);
