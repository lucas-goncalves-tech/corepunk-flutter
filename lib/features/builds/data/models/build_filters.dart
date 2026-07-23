import 'package:flutter/foundation.dart';

class BuildFilters {
  final String mastery;
  final List<String> tags;

  const BuildFilters({
    this.mastery = '',
    this.tags = const [],
  });

  BuildFilters copyWith({
    String? mastery,
    List<String>? tags,
  }) {
    return BuildFilters(
      mastery: mastery ?? this.mastery,
      tags: tags ?? this.tags,
    );
  }

  static const Map<String, String> tagTranslations = {
    'PvE': 'PvE',
    'PvP': 'PvP',
    'Tank': 'Tanque',
    'Healer': 'Curandeiro',
    'Support': 'Suporte',
    'Damage': 'Dano',
    'Boss Killer': 'Foco em Chefe',
    'Mobs farmer': 'Farm de Mobs',
    'Open World': 'Mundo Aberto',
    'Arena': 'Arena',
    'Battleground': 'Campo de Batalha',
  };

  static String translateTag(String englishTag) {
    return tagTranslations[englishTag] ?? englishTag;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BuildFilters &&
        other.mastery == mastery &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode => Object.hash(mastery, Object.hashAll(tags));
}
