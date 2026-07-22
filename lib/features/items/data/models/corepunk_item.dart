class CorepunkItem {
  final int id;
  final String name;
  final String slug;
  final String quality;
  final String type;
  final int tier;
  final int level;
  final bool upgradable;
  final String? profession;
  final String? mastery;
  final String? descriptionEffect;
  final String? description;
  final String? archetype;
  final String? sex;
  final String? slot;
  final List<String> tags;

  const CorepunkItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.quality,
    required this.type,
    required this.tier,
    required this.level,
    this.upgradable = false,
    this.profession,
    this.mastery,
    this.descriptionEffect,
    this.description,
    this.archetype,
    this.sex,
    this.slot,
    this.tags = const [],
  });

  String get imageUrl => 'https://d2fwno52vggyhx.cloudfront.net/items/$type/$slug.png';

  factory CorepunkItem.fromJson(Map<String, dynamic> json) {
    final List<String> extractedTags = [];
    try {
      if (json['tags'] is List) {
        for (final t in json['tags'] as List) {
          if (t is Map && t['name'] != null) {
            extractedTags.add(t['name'].toString());
          } else if (t != null) {
            extractedTags.add(t.toString());
          }
        }
      }
    } catch (_) {}

    return CorepunkItem(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      name: json['name']?.toString() ?? 'Item sem nome',
      slug: json['slug']?.toString() ?? '',
      quality: json['quality']?.toString().toLowerCase() ?? 'common',
      type: json['type']?.toString().toLowerCase() ?? '',
      tier: (json['tier'] is num) ? (json['tier'] as num).toInt() : 1,
      level: (json['level'] is num) ? (json['level'] as num).toInt() : 1,
      upgradable: json['upgradable'] == true,
      profession: json['profession']?.toString(),
      mastery: json['mastery']?.toString(),
      descriptionEffect: json['descriptionEffect']?.toString(),
      description: json['description']?.toString(),
      archetype: json['archetype']?.toString(),
      sex: json['sex']?.toString(),
      slot: json['slot']?.toString(),
      tags: extractedTags,
    );
  }
}
