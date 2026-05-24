import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void updateDate(DateTime newDate) => state = newDate;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedTimeNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void updateTime(String? newTime) => state = newTime;
}

final selectedTimeProvider = NotifierProvider<SelectedTimeNotifier, String?>(SelectedTimeNotifier.new);

final bookedTimeSlotsProvider = StreamProvider<List<String>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

  return FirebaseFirestore.instance
      .collection('appointments')
      .where('date', isEqualTo: formattedDate)
      .where('status', isEqualTo: 'confirmed')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => doc.data()['timeSlot'] as String)
        .toList();
  });
});

final myAppointmentsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('appointments')
      .where('clientId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    final docs = snapshot.docs.map((doc) => doc.data()).toList();
    // Sort locally in Dart so we don't have to wait for another Firestore Index to build!
    docs.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    return docs;
  });
});