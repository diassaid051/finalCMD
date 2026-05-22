import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/trips_repository.dart';
import 'add_trip_sheet.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои маршруты')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const AddTripSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (trips) => trips.isEmpty
            ? const Center(child: Text('Нет маршрутов. Нажми +'))
            : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, i) {
                  final trip = trips[i];
                  return ListTile(
                    leading: const Icon(Icons.flight_takeoff),
                    title: Text(trip.title),
                    subtitle: Text(trip.destination),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          ref.read(tripsRepositoryProvider).deleteTrip(trip.id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// Провайдер для стрима поездок
final tripsStreamProvider = StreamProvider((ref) {
  return ref.watch(tripsRepositoryProvider).watchAllTrips();
});
