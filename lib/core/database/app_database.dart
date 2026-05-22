import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Это таблица поездок — как таблица в Excel
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get destination => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get notes => text().nullable()();
}

// Это таблица избранных мест
class FavoritePlaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get country => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Trips, FavoritePlaces])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- Методы для поездок ---

  Future<List<Trip>> getAllTrips() => select(trips).get();

  Stream<List<Trip>> watchAllTrips() => select(trips).watch();

  Future<int> insertTrip(TripsCompanion trip) => into(trips).insert(trip);

  Future<bool> updateTrip(Trip trip) => update(trips).replace(trip);

  Future<int> deleteTrip(int id) =>
      (delete(trips)..where((t) => t.id.equals(id))).go();

  // --- Методы для избранного ---

  Future<List<FavoritePlace>> getFavorites() => select(favoritePlaces).get();

  Stream<List<FavoritePlace>> watchFavorites() =>
      select(favoritePlaces).watch();

  Future<int> addFavorite(FavoritePlacesCompanion place) =>
      into(favoritePlaces).insert(place);

  Future<int> removeFavorite(String id) =>
      (delete(favoritePlaces)..where((p) => p.id.equals(id))).go();
}

// Это открывает файл базы данных на телефоне/компьютере
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'travel_planner.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
