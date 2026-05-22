import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/search_repository.dart';
import '../domain/place.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultsProvider = FutureProvider<List<Place>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.length < 3) return [];
  return ref.watch(searchRepositoryProvider).searchPlaces(query);
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск мест')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Введи город или страну...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  ref.read(searchQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (places) => places.isEmpty
                  ? const Center(child: Text('Введи минимум 3 буквы'))
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, i) {
                        final place = places[i];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(place.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(place.country),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
