import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(ref.watch(databaseProvider));
});

class TripsRepository {
  final AppDatabase _db;
  TripsRepository(this._db);

  Stream<List<Trip>> watchAllTrips() => _db.watchAllTrips();

  Future<void> addTrip({
    required String title,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    String? notes,
  }) {
    return _db.insertTrip(TripsCompanion(
      title: Value(title),
      destination: Value(destination),
      startDate: Value(startDate),
      endDate: Value(endDate),
      notes: Value(notes),
    ));
  }

  Future<void> deleteTrip(int id) => _db.deleteTrip(id);
}
