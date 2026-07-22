import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/corepunk_item.dart';
import '../data/models/item_filters.dart';
import '../data/repositories/items_repository.dart';

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository();
});

final itemsProvider = FutureProvider.family<List<CorepunkItem>, ItemFilters>((
  ref,
  filters,
) async {
  final repository = ref.watch(itemsRepositoryProvider);
  return repository.fetchItems(filters);
});
