import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientPricesNotifier extends StateNotifier<Map<String, double>> {
  IngredientPricesNotifier() : super({});

  void setPrice(String ingredientSlug, double price) {
    state = {
      ...state,
      ingredientSlug: price,
    };
  }

  double getPrice(String ingredientSlug) {
    return state[ingredientSlug] ?? 0.0;
  }
}

final ingredientPricesProvider =
    StateNotifierProvider<IngredientPricesNotifier, Map<String, double>>((ref) {
  return IngredientPricesNotifier();
});
