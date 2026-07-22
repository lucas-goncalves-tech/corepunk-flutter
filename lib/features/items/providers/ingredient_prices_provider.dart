import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';

class IngredientPricesNotifier extends StateNotifier<Map<String, double>> {
  IngredientPricesNotifier() : super(StorageService.getAllPrices());

  void setPrice(String ingredientSlug, double price) {
    state = {
      ...state,
      ingredientSlug: price,
    };
    StorageService.savePriceDebounced(ingredientSlug, price);
  }

  double getPrice(String ingredientSlug) {
    return state[ingredientSlug] ?? 0.0;
  }
}

final ingredientPricesProvider =
    StateNotifierProvider<IngredientPricesNotifier, Map<String, double>>((ref) {
  return IngredientPricesNotifier();
});
