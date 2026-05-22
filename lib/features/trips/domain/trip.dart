class Trip {
  final int? id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;

  const Trip({
    this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.notes,
  });
}
