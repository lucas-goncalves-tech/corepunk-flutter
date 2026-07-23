class BuildGuide {
  final int id;
  final String title;
  final String buildPlannerLink;
  final String youtubeLink;
  final String masteryName;
  final String authorName;
  final List<String> tags;
  final DateTime? createdAt;
  final String description;
  final String pros;
  final String cons;
  final String gameplay;

  const BuildGuide({
    required this.id,
    required this.title,
    required this.buildPlannerLink,
    required this.youtubeLink,
    required this.masteryName,
    required this.authorName,
    required this.tags,
    this.createdAt,
    this.description = '',
    this.pros = '',
    this.cons = '',
    this.gameplay = '',
  });

  static String _parseRichText(dynamic jsonBlock) {
    if (jsonBlock == null) return '';
    List<dynamic> blocks = [];
    if (jsonBlock is List) {
      blocks = jsonBlock;
    } else if (jsonBlock is Map && jsonBlock['content'] is List) {
      blocks = jsonBlock['content'] as List<dynamic>;
    } else {
      return '';
    }

    final buffer = StringBuffer();
    for (final block in blocks) {
      if (block is Map && block['content'] is List) {
        for (final textNode in block['content']) {
          if (textNode is Map && textNode['type'] == 'text') {
            buffer.write(textNode['text'] ?? '');
          }
        }
        buffer.writeln(); // Nova linha entre parágrafos
      }
    }
    return buffer.toString().trim();
  }

  factory BuildGuide.fromJson(Map<String, dynamic> json) {
    // Extraindo tags de forma segura
    final List<String> parsedTags = [];
    if (json['tags'] is List) {
      for (final tag in json['tags']) {
        if (tag is Map && tag['name'] != null) {
          parsedTags.add(tag['name'].toString());
        }
      }
    }

    // Extraindo master e author com segurança
    final masteryMap = json['mastery'] as Map<String, dynamic>?;
    final authorMap = json['author'] as Map<String, dynamic>?;

    return BuildGuide(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sem Título',
      buildPlannerLink: json['buildPlannerLink'] ?? '',
      youtubeLink: json['youtubeLink'] ?? '',
      masteryName: masteryMap?['name'] ?? 'Desconhecido',
      authorName: authorMap?['username'] ?? 'Anônimo',
      tags: parsedTags,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      description: _parseRichText(json['description']),
      pros: _parseRichText(json['pros']),
      cons: _parseRichText(json['cons']),
      gameplay: _parseRichText(json['gameplay']),
    );
  }
}
