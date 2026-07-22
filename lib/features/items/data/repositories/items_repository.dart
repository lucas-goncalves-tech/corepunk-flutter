import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/corepunk_item.dart';
import '../models/item_filters.dart';

class ItemsRepository {
  final http.Client _client;

  ItemsRepository({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = 'https://corepunk.help/api/items/by-category';

  Future<List<CorepunkItem>> fetchItems(ItemFilters filters) async {
    final filtersJson = Uri.encodeComponent(filters.toApiJsonString());
    final url = Uri.parse('$baseUrl?page=${filters.page}&size=${filters.size}&filters=$filtersJson');

    final response = await _client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'CorepunkApp/1.0',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>? ?? [];

      return dataList
          .whereType<Map<String, dynamic>>()
          .map((itemJson) => CorepunkItem.fromJson(itemJson))
          .toList();
    } else {
      throw Exception('Erro ao carregar itens da API: ${response.statusCode}');
    }
  }
}
