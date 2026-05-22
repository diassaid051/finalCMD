import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/trips_repository.dart';

class AddTripSheet extends ConsumerStatefulWidget {
  const AddTripSheet({super.key});

  @override
  ConsumerState<AddTripSheet> createState() => _AddTripSheetState();
}

class _AddTripSheetState extends ConsumerState<AddTripSheet> {
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Новый маршрут',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
                labelText: 'Название поездки', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _destinationController,
            decoration: const InputDecoration(
                labelText: 'Куда едем?', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setState(() => _startDate = d);
                  },
                  child: Text(
                      'Начало: ${_startDate.day}.${_startDate.month}.${_startDate.year}'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: _startDate,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setState(() => _endDate = d);
                  },
                  child: Text(
                      'Конец: ${_endDate.day}.${_endDate.month}.${_endDate.year}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _destinationController.text.isEmpty) return;
                await ref.read(tripsRepositoryProvider).addTrip(
                      title: _titleController.text,
                      destination: _destinationController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }
}
