class Place {
  final String id;
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? description;

  const Place({
    required this.id,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.description,
  });

  // Это нужно чтобы превратить JSON из интернета в объект Place
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lon'] ?? 0).toDouble(),
      description: json['description'],
    );
  }
}
