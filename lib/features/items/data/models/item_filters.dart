import 'dart:convert';

class ItemFilters {
  final String type;
  final String quality;
  final String tier;
  final String profession;
  final String mastery;
  final String name;
  final int page;
  final int size;

  const ItemFilters({
    this.type = '',
    this.quality = '',
    this.tier = '',
    this.profession = '',
    this.mastery = '',
    this.name = '',
    this.page = 1,
    this.size = 25,
  });

  ItemFilters copyWith({
    String? type,
    String? quality,
    String? tier,
    String? profession,
    String? mastery,
    String? name,
    int? page,
    int? size,
  }) {
    return ItemFilters(
      type: type ?? this.type,
      quality: quality ?? this.quality,
      tier: tier ?? this.tier,
      profession: profession ?? this.profession,
      mastery: mastery ?? this.mastery,
      name: name ?? this.name,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  String toApiJsonString() {
    final map = {
      'profession': profession,
      'mastery': mastery,
      'type': type,
      'tier': tier,
      'quality': quality,
      'tags': [],
      'name': name,
      'sort': 'name:asc',
    };
    return jsonEncode(map);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemFilters &&
        other.type == type &&
        other.quality == quality &&
        other.tier == tier &&
        other.profession == profession &&
        other.mastery == mastery &&
        other.name == name &&
        other.page == page &&
        other.size == size;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      quality,
      tier,
      profession,
      mastery,
      name,
      page,
      size,
    );
  }
}
