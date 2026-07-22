import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/corepunk_item_detail.dart';

class ItemTranslationService {
  static final Map<String, CorepunkItemDetail> _memoryCache = {};

  static final Map<String, String> _termDictionary = {
    'Chance On-hit': 'Chance ao Atingir',
    'On-ability use': 'Ao usar habilidade',
    'Weapon Damage': 'Dano de Arma',
    'Magic Damage': 'Dano Mágico',
    'Physical Damage': 'Dano Físico',
    'Poison': 'Veneno',
    'armor': 'Armadura',
    'ap': 'Poder de Ataque',
    'sp': 'Poder Mágico',
    'as': 'Velocidade de Ataque',
    'wd': 'Dano de Arma',
    'mpen': 'Penetração Mágica',
    'cd': 'Tempo de Recarga',
  };

  static final Map<String, Map<String, String>> _manualOverrides = {
    '203430': {
      'name': 'Picada Ácida',
      'description': 'A Manopla Picada Ácida é uma ferramenta de combate corpo a corpo mortal, incorporando um toque venenoso ao seu design.',
    },
  };

  static Future<String> _translateTextApi(String input) async {
    if (input.trim().isEmpty) return input;

    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=pt&dt=t&q=${Uri.encodeComponent(input)}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final translatedChunks = data[0] as List<dynamic>;
        final sb = StringBuffer();
        for (final chunk in translatedChunks) {
          if (chunk is List && chunk.isNotEmpty) {
            sb.write(chunk[0].toString());
          }
        }
        return sb.toString();
      }
    } catch (_) {}

    return input;
  }

  static Future<CorepunkItemDetail> translateItemDetail(CorepunkItemDetail original) async {
    final cacheKey = '${original.id}_${original.quality}';
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey]!;
    }

    final String itemIdStr = original.id.toString();
    final override = _manualOverrides[itemIdStr];

    String translatedName = original.name;
    String translatedDescription = original.description ?? '';
    String translatedDescriptionEffect = original.descriptionEffect ?? '';

    if (override != null) {
      translatedName = override['name'] ?? original.name;
      translatedDescription = override['description'] ?? original.description ?? '';
    } else {
      translatedName = await _translateTextApi(original.name);
      if (original.description != null && original.description!.isNotEmpty) {
        translatedDescription = await _translateTextApi(original.description!);
      }
      if (original.descriptionEffect != null && original.descriptionEffect!.isNotEmpty) {
        translatedDescriptionEffect = await _translateTextApi(original.descriptionEffect!);
      }
    }

    _termDictionary.forEach((en, pt) {
      translatedDescriptionEffect = translatedDescriptionEffect.replaceAll(en, pt);
      translatedDescriptionEffect = translatedDescriptionEffect.replaceAll('[$en]', pt);
    });

    final translatedDetail = CorepunkItemDetail(
      id: original.id,
      name: translatedName,
      slug: original.slug,
      quality: original.quality,
      type: original.type,
      tier: original.tier,
      level: original.level,
      profession: original.profession,
      professionLevel: original.professionLevel,
      description: translatedDescription,
      descriptionEffect: translatedDescriptionEffect,
      stats: original.stats,
      workbenchIngredients: original.workbenchIngredients,
      synthesisRecipes: original.synthesisRecipes,
      specialEffect: (original.specialEffect != null)
          ? SpecialEffectInfo(
              id: original.specialEffect!.id,
              title: _termDictionary[original.specialEffect!.title] ?? original.specialEffect!.title,
              descriptionEffect: translatedDescriptionEffect,
            )
          : null,
    );

    _memoryCache[cacheKey] = translatedDetail;
    return translatedDetail;
  }
}
