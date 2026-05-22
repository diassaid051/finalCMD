import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});

class SharedTrip {
  final String id;
  final String title;
  final String destination;
  final String createdBy;
  final DateTime createdAt;

  SharedTrip({
    required this.id,
    required this.title,
    required this.destination,
    required this.createdBy,
    required this.createdAt,
  });

  factory SharedTrip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SharedTrip(
      id: doc.id,
      title: data['title'] ?? '',
      destination: data['destination'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'destination': destination,
        'createdBy': createdBy,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}

class FirestoreRepository {
  final FirebaseFirestore _db;
  FirestoreRepository(this._db);

  // Получаем все общие маршруты из облака
  Stream<List<SharedTrip>> watchSharedTrips() {
    return _db
        .collection('shared_trips')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(SharedTrip.fromFirestore).toList());
  }

  // Добавляем маршрут в облако
  Future<void> shareTrip({
    required String title,
    required String destination,
    required String createdBy,
  }) {
    return _db.collection('shared_trips').add(SharedTrip(
          id: '',
          title: title,
          destination: destination,
          createdBy: createdBy,
          createdAt: DateTime.now(),
        ).toMap());
  }

  // Удаляем маршрут из облака
  Future<void> deleteSharedTrip(String id) {
    return _db.collection('shared_trips').doc(id).delete();
  }
}
