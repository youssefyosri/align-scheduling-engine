import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../domain/booking_repository.dart';
import '../domain/booking_state_provider.dart';
import '../../services/domain/service_model.dart';

class BookingCalendarScreen extends ConsumerWidget {
  void _showBookingSummary(
      BuildContext context,
      WidgetRef ref,
      DateTime date,
      String time,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BOOKING SUMMARY',
                  style: TextStyle(fontSize: 14, letterSpacing: 1.5, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Date Details
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(date),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Time Details
                Row(
                  children: [
                    Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      '$time (${service.durationMinutes} Min)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price Details
                Row(
                  children: [
                    Icon(Icons.payments_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Final Book Button
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      await ref.read(bookingRepositoryProvider).createAppointment(
                        serviceId: service.id,
                        date: date,
                        timeSlot: time,
                        price: service.price,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Appointment Confirmed!')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Confirm & Book Now'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final ServiceModel service;

  const BookingCalendarScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final bookedSlotsAsync = ref.watch(bookedTimeSlotsProvider);

    final timeSlots = [
      '09:00 AM', '10:00 AM', '11:00 AM',
      '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SELECT TIME', style: TextStyle(letterSpacing: 1.5)),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardTheme.color,
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                ref.read(selectedDateProvider.notifier).updateDate(selectedDay);
                ref.read(selectedTimeProvider.notifier).updateTime(null);
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: bookedSlotsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading slots: $err')),
              data: (bookedSlots) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = timeSlots[index];

                    final isBooked = bookedSlots.contains(time);
                    final isSelected = time == selectedTime;

                    return InkWell(
                      onTap: isBooked ? null : () {
                        ref.read(selectedTimeProvider.notifier).updateTime(time);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isBooked
                              ? Colors.grey.withValues(alpha: 0.2)
                              : isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: isBooked
                                ? Colors.transparent
                                : isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // Strike-through text if booked
                            decoration: isBooked ? TextDecoration.lineThrough : null,
                            color: isBooked
                                ? Colors.grey
                                : isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: selectedTime == null ? null : () {
                  _showBookingSummary(context, ref, selectedDate, selectedTime);
                },
                child: const Text('Review Appointment'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}