import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_provider.dart';
import '../domain/place.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(placesApiProvider));
});

class SearchRepository {
  final dynamic _api;
  SearchRepository(this._api);

  Future<List<Place>> searchPlaces(String query) async {
    final response = await _api.searchPlaces(query, 'json', 10);
    if (response.isSuccessful) {
      final List<dynamic> data = jsonDecode(response.bodyString);
      return data
          .map((json) => Place(
                id: json['place_id'].toString(),
                name: json['display_name'] ?? '',
                country: json['address']?['country'] ?? '',
                latitude: double.tryParse(json['lat'] ?? '0') ?? 0,
                longitude: double.tryParse(json['lon'] ?? '0') ?? 0,
              ))
          .toList();
    }
    return [];
  }
}
