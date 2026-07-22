import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/corepunk_item_detail.dart';

class ItemCraftingCalculatorWidget extends StatefulWidget {
  final CorepunkItemDetail item;

  const ItemCraftingCalculatorWidget({
    super.key,
    required this.item,
  });

  @override
  State<ItemCraftingCalculatorWidget> createState() => _ItemCraftingCalculatorWidgetState();
}

class _ItemCraftingCalculatorWidgetState extends State<ItemCraftingCalculatorWidget> {
  int _selectedRecipeIndex = 0;
  int _craftQuantity = 1;
  final Map<int, int> _unitGoldCosts = {};

  @override
  Widget build(BuildContext context) {
    if (widget.item.workbenchIngredients.isEmpty) {
      return const SizedBox.shrink();
    }

    final recipes = widget.item.synthesisRecipes;
    final activeRecipe = (recipes.isNotEmpty && _selectedRecipeIndex < recipes.length)
        ? recipes[_selectedRecipeIndex]
        : CraftRecipeInfo(name: 'Bancada (Workbench)', ingredients: widget.item.workbenchIngredients);

    int grandTotalGold = 0;
    for (final ing in activeRecipe.ingredients) {
      final unitCost = _unitGoldCosts[ing.id] ?? 0;
      grandTotalGold += (unitCost * ing.quantity * _craftQuantity);
    }

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CRAFTING',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (recipes.length > 1)
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedRecipeIndex,
                    dropdownColor: AppColors.popover,
                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRecipeIndex = val);
                    },
                    items: List.generate(recipes.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(recipes[index].name),
                      );
                    }),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: activeRecipe.ingredients.map((ing) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            ing.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.mutedForeground),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '${ing.quantity}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 24, color: AppColors.border),
          const Text(
            'CALCULADORA DE CUSTOS EM OURO',
            style: TextStyle(
              color: AppColors.mutedForeground,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...activeRecipe.ingredients.map((ing) {
            final unitCost = _unitGoldCosts[ing.id] ?? 0;
            final subtotal = unitCost * ing.quantity * _craftQuantity;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(
                        ing.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.mutedForeground),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ing.name,
                      style: const TextStyle(color: AppColors.cardForeground, fontSize: 12),
                    ),
                  ),
                  Text(
                    'x${ing.quantity * _craftQuantity}  ',
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 11),
                  ),
                  SizedBox(
                    width: 70,
                    height: 32,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '0g',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _unitGoldCosts[ing.id] = int.tryParse(val) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${subtotal}g',
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Fabricar Qtd: ', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, size: 18, color: AppColors.primary),
                      onPressed: () {
                        if (_craftQuantity > 1) setState(() => _craftQuantity--);
                      },
                    ),
                    Text('$_craftQuantity', style: const TextStyle(color: AppColors.cardForeground, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primary),
                      onPressed: () => setState(() => _craftQuantity++),
                    ),
                  ],
                ),
                Text(
                  'Total: ${grandTotalGold}g',
                  style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
