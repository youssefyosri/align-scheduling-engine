class ServiceModel {
  final String id;
  final String title;
  final int durationMinutes;
  final double price;
  final String description;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.price,
    required this.description,
  });
}