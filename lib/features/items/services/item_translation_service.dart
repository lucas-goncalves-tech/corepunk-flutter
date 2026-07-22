import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/corepunk_item_detail.dart';

class ItemTranslationService {
  static final Map<String, CorepunkItemDetail> _memoryCache = {};

  static final Map<String, Map<String, String>> _manualOverrides = {
    '203430': {
      'name': 'Picada Ácida',
      'description': 'A Manopla Picada Ácida é uma ferramenta de combate corpo a corpo mortal, incorporando um toque venenoso ao seu design.',
    },
  };

  static String _cleanAndTranslateEffectText(String input) {
    if (input.trim().isEmpty) return input;
    String text = input;

    final Map<String, String> phrases = {
      'Chance On-hit': 'Chance ao Atingir',
      'On-ability use': 'Ao usar habilidade',
      'Your attacks have a': 'Seus ataques têm de',
      'chance to apply': 'chance de aplicar',
      'Each stack deals': 'Cada acúmulo causa',
      'per second over': 'por segundo durante',
      'seconds': 'segundos',
      'Can stack up to': 'Pode acumular até',
      'times': 'vezes',
    };

    phrases.forEach((en, pt) {
      text = text.replaceAll(en, pt);
    });

    final Map<String, String> bracketTags = {
      r'\[ap\]': 'Poder de Ataque',
      r'\[wd\]': 'Dano de Arma',
      r'\[md\]': 'Dano Mágico',
      r'\[sp\]': 'Poder Mágico',
      r'\[armor\]': 'Armadura',
      r'\[poison\]': 'Veneno',
      r'\[cd\]': 'Recarga',
      r'\[as\]': 'Velocidade de Ataque',
      r'\[hp\]': 'Vida',
      r'\[mp\]': 'Mana',
    };

    bracketTags.forEach((pattern, replacement) {
      text = text.replaceAll(RegExp(pattern), replacement);
    });

    return text;
  }

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
    }

    if (original.descriptionEffect != null && original.descriptionEffect!.isNotEmpty) {
      translatedDescriptionEffect = _cleanAndTranslateEffectText(original.descriptionEffect!);
    }

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
              title: _cleanAndTranslateEffectText(original.specialEffect!.title),
              descriptionEffect: translatedDescriptionEffect,
            )
          : null,
    );

    _memoryCache[cacheKey] = translatedDetail;
    return translatedDetail;
  }
}
