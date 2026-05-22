import 'package:chopper/chopper.dart';

part 'places_api.chopper.dart';

// Это описание API — говорим Chopper куда делать запросы
@ChopperApi(baseUrl: '/search')
abstract class PlacesApiService extends ChopperService {
  // Поиск мест по названию
  @Get()
  Future<Response> searchPlaces(
    @Query('q') String query,
    @Query('format') String format,
    @Query('limit') int limit,
  );

  static PlacesApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://nominatim.openstreetmap.org'),
      services: [_$PlacesApiService()],
      interceptors: [
        // Добавляем заголовок — иначе API не отвечает
        (Request request) async => request.copyWith(headers: {
              ...request.headers,
              'User-Agent': 'TravelPlannerApp/1.0',
            }),
        HttpLoggingInterceptor(),
      ],
      converter: const JsonConverter(),
    );
    return _$PlacesApiService(client);
  }
}
