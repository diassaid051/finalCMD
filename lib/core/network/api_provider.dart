import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'places_api.dart';

final placesApiProvider = Provider<PlacesApiService>((ref) {
  return PlacesApiService.create();
});
