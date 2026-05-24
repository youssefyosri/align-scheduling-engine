import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createAppointment({
    required String serviceId,
    required DateTime date,
    required String timeSlot,
    required double price,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Create a unique ID for the appointment
    final appointmentRef = _firestore.collection('appointments').doc();
    await appointmentRef.set({
      'appointmentId': appointmentRef.id,
      'clientId': user.uid,
      'serviceId': serviceId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'timeSlot': timeSlot,
      'price': price,
      'status': 'confirmed',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final bookingRepositoryProvider = Provider((ref) => BookingRepository());