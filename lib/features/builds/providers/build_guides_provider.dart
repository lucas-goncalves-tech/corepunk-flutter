import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../data/models/build_guide.dart';

import '../data/models/build_filters.dart';

class BuildGuidesState {
  final List<BuildGuide> builds;
  final bool hasMore;
  final bool isLoadingMore;

  const BuildGuidesState({
    required this.builds,
    required this.hasMore,
    required this.isLoadingMore,
  });

  BuildGuidesState copyWith({
    List<BuildGuide>? builds,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return BuildGuidesState(
      builds: builds ?? this.builds,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class BuildGuidesNotifier extends FamilyAsyncNotifier<BuildGuidesState, BuildFilters> {
  static const int pageSize = 5;

  @override
  FutureOr<BuildGuidesState> build(BuildFilters arg) async {
    return _fetchPage(1, arg);
  }

  Future<BuildGuidesState> _fetchPage(int page, BuildFilters filters) async {
    String url = 'https://corepunk.help/api/build-guides?page=$page&size=$pageSize';
    
    Map<String, dynamic> apiFilters = {};
    if (filters.mastery.isNotEmpty) {
      apiFilters["mastery"] = filters.mastery;
    }
    if (filters.tags.isNotEmpty) {
      apiFilters["tags"] = filters.tags;
    }

    if (apiFilters.isNotEmpty) {
      final filtersJson = jsonEncode(apiFilters);
      url += '&filters=${Uri.encodeComponent(filtersJson)}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> dataList = data['data'] ?? [];
      final builds = dataList.map((json) => BuildGuide.fromJson(json)).toList();

      final meta = data['meta']?['pagination'];
      final int pageCount = meta?['pageCount'] ?? 1;
      final bool hasMore = page < pageCount;

      return BuildGuidesState(
        builds: builds,
        hasMore: hasMore,
        isLoadingMore: false,
      );
    } else {
      throw Exception('Failed to load build guides');
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasError) return;
    
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final int nextPage = (currentState.builds.length ~/ pageSize) + 1;
      final nextState = await _fetchPage(nextPage, arg);

      state = AsyncValue.data(
        BuildGuidesState(
          builds: [...currentState.builds, ...nextState.builds],
          hasMore: nextState.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final buildGuidesProvider = AsyncNotifierProviderFamily<BuildGuidesNotifier, BuildGuidesState, BuildFilters>(
  BuildGuidesNotifier.new,
);
