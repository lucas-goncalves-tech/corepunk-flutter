class IngredientItem {
  final int id;
  final String name;
  final int quantity;
  final String type;
  final String slug;

  const IngredientItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.type,
    required this.slug,
  });

  String get imageUrl => 'https://d2fwno52vggyhx.cloudfront.net/items/$type/$slug.png';

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    final rawName = json['name']?.toString() ?? '';
    final rawType = json['type']?.toString().toLowerCase() ?? 'resource';
    final rawSlug = json['slug']?.toString() ?? rawName.toLowerCase().replaceAll(' ', '-');

    return IngredientItem(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      name: rawName,
      quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : 1,
      type: rawType,
      slug: rawSlug,
    );
  }
}

class ItemStatInfo {
  final int id;
  final String type;
  final double min;
  final double max;

  const ItemStatInfo({
    required this.id,
    required this.type,
    required this.min,
    required this.max,
  });

  factory ItemStatInfo.fromJson(Map<String, dynamic> json) {
    return ItemStatInfo(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      type: json['type']?.toString() ?? '',
      min: (json['min'] is num) ? (json['min'] as num).toDouble() : 0.0,
      max: (json['max'] is num) ? (json['max'] as num).toDouble() : 0.0,
    );
  }
}

class SpecialEffectInfo {
  final int id;
  final String title;
  final String descriptionEffect;

  const SpecialEffectInfo({
    required this.id,
    required this.title,
    required this.descriptionEffect,
  });

  factory SpecialEffectInfo.fromJson(Map<String, dynamic> json) {
    return SpecialEffectInfo(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      title: json['title']?.toString() ?? '',
      descriptionEffect: json['descriptionEffect']?.toString() ?? '',
    );
  }
}

class CraftRecipeInfo {
  final String name;
  final List<IngredientItem> ingredients;

  const CraftRecipeInfo({
    required this.name,
    required this.ingredients,
  });
}

class CorepunkItemDetail {
  final int id;
  final String name;
  final String slug;
  final String quality;
  final String type;
  final int tier;
  final int level;
  final String? profession;
  final String? professionLevel;
  final String? description;
  final String? descriptionEffect;
  final List<ItemStatInfo> stats;
  final List<IngredientItem> workbenchIngredients;
  final List<CraftRecipeInfo> synthesisRecipes;
  final SpecialEffectInfo? specialEffect;

  const CorepunkItemDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.quality,
    required this.type,
    required this.tier,
    required this.level,
    this.profession,
    this.professionLevel,
    this.description,
    this.descriptionEffect,
    this.stats = const [],
    this.workbenchIngredients = const [],
    this.synthesisRecipes = const [],
    this.specialEffect,
  });

  String get imageUrl => getImageUrlForQuality(quality);

  String getImageUrlForQuality(String targetQuality) {
    final cleanSlug = slug.replaceAll(RegExp(r'-(common|uncommon|rare|epic)$'), '');
    final q = targetQuality.toLowerCase();
    if (q == 'common') {
      return 'https://d2fwno52vggyhx.cloudfront.net/items/$type/$cleanSlug.png';
    } else {
      return 'https://d2fwno52vggyhx.cloudfront.net/items/$type/$cleanSlug-$q.png';
    }
  }

  factory CorepunkItemDetail.fromJson(Map<String, dynamic> json) {
    final rawStats = (json['stats'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((s) => ItemStatInfo.fromJson(s))
        .toList();

    final rawIngredients = (json['ingredients'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((i) => IngredientItem.fromJson(i))
        .toList();

    SpecialEffectInfo? effect;
    if (json['specialEffect'] is Map<String, dynamic>) {
      effect = SpecialEffectInfo.fromJson(json['specialEffect'] as Map<String, dynamic>);
    }

    final recipes = <CraftRecipeInfo>[];
    if (rawIngredients.isNotEmpty) {
      recipes.add(CraftRecipeInfo(
        name: 'Bancada (Workbench)',
        ingredients: rawIngredients,
      ));
    }

    return CorepunkItemDetail(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      name: json['name']?.toString() ?? 'Item sem nome',
      slug: json['slug']?.toString() ?? '',
      quality: json['quality']?.toString().toLowerCase() ?? 'common',
      type: json['type']?.toString().toLowerCase() ?? '',
      tier: (json['tier'] is num) ? (json['tier'] as num).toInt() : 1,
      level: (json['level'] is num) ? (json['level'] as num).toInt() : 1,
      profession: json['profession']?.toString(),
      professionLevel: json['professionLevel']?.toString(),
      description: json['description']?.toString(),
      descriptionEffect: json['descriptionEffect']?.toString(),
      stats: rawStats,
      workbenchIngredients: rawIngredients,
      synthesisRecipes: recipes,
      specialEffect: effect,
    );
  }
}
