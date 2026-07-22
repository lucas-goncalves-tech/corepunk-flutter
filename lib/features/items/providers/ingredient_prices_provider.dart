import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientPricesNotifier extends StateNotifier<Map<String, int>> {
  IngredientPricesNotifier() : super({});

  void setPrice(String ingredientSlug, int price) {
    state = {
      ...state,
      ingredientSlug: price,
    };
  }

  int getPrice(String ingredientSlug) {
    return state[ingredientSlug] ?? 0;
  }
}

final ingredientPricesProvider =
    StateNotifierProvider<IngredientPricesNotifier, Map<String, int>>((ref) {
  return IngredientPricesNotifier();
});
