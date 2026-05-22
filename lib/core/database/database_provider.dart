import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

// Провайдер — это как "розетка", любой экран может подключиться и взять БД
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close()); // закрываем БД когда не нужна
  return db;
});
