import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firestore_repository.dart';

final sharedTripsProvider = StreamProvider<List<SharedTrip>>((ref) {
  return ref.watch(firestoreRepositoryProvider).watchSharedTrips();
});

class SharedTripsScreen extends ConsumerWidget {
  const SharedTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(sharedTripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Общие маршруты')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.share),
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (trips) => trips.isEmpty
            ? const Center(
                child: Text('Нет общих маршрутов. Нажми кнопку поделиться'))
            : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, i) {
                  final trip = trips[i];
                  return ListTile(
                    leading: const Icon(Icons.public),
                    title: Text(trip.title),
                    subtitle: Text('${trip.destination} • ${trip.createdBy}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ref
                          .read(firestoreRepositoryProvider)
                          .deleteSharedTrip(trip.id),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final destinationController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поделиться маршрутом'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ваше имя'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: 'Куда едем?'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(firestoreRepositoryProvider).shareTrip(
                    title: titleController.text,
                    destination: destinationController.text,
                    createdBy: nameController.text,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Поделиться'),
          ),
        ],
      ),
    );
  }
}
