import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_model.dart';

final availableServicesProvider = Provider<List<ServiceModel>>((ref) {
  return const [
    ServiceModel(
      id: 'srv_01',
      title: 'Executive Consultation',
      durationMinutes: 45,
      price: 120.00,
      description: 'A comprehensive 45-minute strategic alignment session.',
    ),
    ServiceModel(
      id: 'srv_02',
      title: 'Standard Review',
      durationMinutes: 30,
      price: 75.00,
      description: 'Quick alignment check and progress update.',
    ),
    ServiceModel(
      id: 'srv_03',
      title: 'Deep Dive Strategy',
      durationMinutes: 90,
      price: 200.00,
      description: 'Intensive 90-minute planning and architecture block.',
    ),
  ];
});