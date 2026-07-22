import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/storage_service.dart';
import '../data/models/corepunk_item_detail.dart';

class ItemTranslationService {
  static final Map<String, CorepunkItemDetail> _memoryCache = {};

  static final Map<String, String> _professionMap = {
    'mining': 'Mineração',
    'logging': 'Corte de Madeira',
    'butchery': 'Açougue',
    'herbalism': 'Herbologia',
    'construction': 'Construção',
    'weaponsmithing': 'Armaria',
    'mysticism': 'Misticismo',
    'alchemy': 'Alquimia',
    'cooking': 'Culinária',
    'other': 'Outro',
  };

  static final Map<String, Map<String, String>> _manualOverrides = {
    '203430': {
      'name': 'Picada Ácida',
      'description': 'A Manopla Picada Ácida é uma ferramenta de combate corpo a corpo mortal, incorporando um toque venenoso ao seu design.',
    },
  };

  static String translateProfession(String profession) {
    return _professionMap[profession.toLowerCase()] ?? profession;
  }

  static String _cleanAndTranslateEffectText(String input) {
    if (input.trim().isEmpty) return input;
    String text = input;

    final Map<String, String> phrases = {
      'Chance On-hit': 'Chance ao Atingir',
      'On-ability use': 'Ao usar habilidade',
      'Increases': 'Aumenta',
      'Increase': 'Aumenta',
      'by': 'em',
      'Duration:': 'Duração:',
      'seconds': 'segundos',
      'second': 'segundo',
    };

    phrases.forEach((en, pt) {
      text = text.replaceAll(en, pt);
    });

    final Map<String, String> bracketTags = {
      r'\[mcc\]': 'Chance Crítica Mágica',
      r'\[pcc\]': 'Chance Crítica Física',
      r'\[mcd\]': 'Dano Crítico Mágico',
      r'\[pcd\]': 'Dano Crítico Físico',
      r'\[mres\]': 'Resistência Mágica',
      r'\[pres\]': 'Resistência Física',
      r'\[ap\]': 'Poder de Ataque',
      r'\[wd\]': 'Dano de Arma',
      r'\[md\]': 'Dano Mágico',
      r'\[pd\]': 'Dano Físico',
      r'\[sp\]': 'Poder Mágico',
      r'\[armor\]': 'Armadura',
      r'\[poison\]': 'Veneno',
      r'\[cd\]': 'Recarga',
      r'\[as\]': 'Velocidade de Ataque',
      r'\[hp\]': 'Vida',
      r'\[mp\]': 'Mana',
      r'\[movespeed\]': 'Velocidade de Movimento',
      r'\[ms\]': 'Velocidade de Movimento',
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

  static Future<CorepunkItemDetail> translateItemDetail(CorepunkItemDetail original, {bool forceRefetch = false}) async {
    final cacheKey = original.id.toString();

    if (!forceRefetch) {
      if (_memoryCache.containsKey(cacheKey)) {
        final cached = _memoryCache[cacheKey]!;
        return CorepunkItemDetail(
          id: cached.id,
          name: cached.name,
          slug: cached.slug,
          quality: original.quality,
          type: cached.type,
          tier: cached.tier,
          level: cached.level,
          profession: cached.profession,
          professionLevel: cached.professionLevel,
          description: cached.description,
          descriptionEffect: cached.descriptionEffect,
          stats: original.stats,
          workbenchIngredients: original.workbenchIngredients,
          synthesisRecipes: original.synthesisRecipes,
          specialEffect: cached.specialEffect ?? original.specialEffect,
        );
      }

      final diskJson = StorageService.getTranslation(cacheKey);
      if (diskJson != null && diskJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(diskJson) as Map<String, dynamic>;
          final String cachedName = decoded['name'] ?? original.name;
          final String cachedDesc = decoded['description'] ?? original.description ?? '';
          final String cachedEffect = decoded['descriptionEffect'] ?? original.descriptionEffect ?? '';
          final String cachedProf = decoded['profession'] ?? (original.profession != null ? translateProfession(original.profession!) : '');

          final diskDetail = CorepunkItemDetail(
            id: original.id,
            name: cachedName,
            slug: original.slug,
            quality: original.quality,
            type: original.type,
            tier: original.tier,
            level: original.level,
            profession: cachedProf,
            professionLevel: original.professionLevel,
            description: cachedDesc,
            descriptionEffect: cachedEffect,
            stats: original.stats,
            workbenchIngredients: original.workbenchIngredients,
            synthesisRecipes: original.synthesisRecipes,
            specialEffect: (cachedEffect.isNotEmpty)
                ? SpecialEffectInfo(
                    id: original.specialEffect?.id ?? 99,
                    title: _cleanAndTranslateEffectText(original.specialEffect?.title ?? 'Chance On-hit'),
                    descriptionEffect: cachedEffect,
                  )
                : original.specialEffect,
          );

          _memoryCache[cacheKey] = diskDetail;
          return diskDetail;
        } catch (_) {}
      }
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
        final apiTranslated = await _translateTextApi(original.descriptionEffect!);
        translatedDescriptionEffect = _cleanAndTranslateEffectText(apiTranslated);
      }
    }

    final String translatedProfession = original.profession != null
        ? translateProfession(original.profession!)
        : '';

    final translatedDetail = CorepunkItemDetail(
      id: original.id,
      name: translatedName,
      slug: original.slug,
      quality: original.quality,
      type: original.type,
      tier: original.tier,
      level: original.level,
      profession: translatedProfession,
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

    final jsonMap = {
      'id': translatedDetail.id,
      'name': translatedDetail.name,
      'slug': translatedDetail.slug,
      'quality': translatedDetail.quality,
      'type': translatedDetail.type,
      'tier': translatedDetail.tier,
      'level': translatedDetail.level,
      'profession': translatedDetail.profession,
      'professionLevel': translatedDetail.professionLevel,
      'description': translatedDetail.description,
      'descriptionEffect': translatedDetail.descriptionEffect,
    };
    StorageService.saveTranslationDebounced(cacheKey, jsonEncode(jsonMap));

    return translatedDetail;
  }
}
