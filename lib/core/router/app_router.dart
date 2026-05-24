import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../auth/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/services/screens/services_screen.dart';
import '../../features/booking/screens/booking_calendar_screen.dart';
import '../../features/booking/screens/my_appointments_screen.dart';
import '../../features/services/domain/service_model.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final analytics = FirebaseAnalytics.instance;

  final authStateListener = ValueNotifier<bool>(false);

  ref.listen(
    authStateProvider,
        (previous, next) {
      authStateListener.value = next;
    },
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authStateListener,
    observers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],
    redirect: (context, state) {
      final isAuthenticated = authStateListener.value;

      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isAuthScreen = isLoggingIn || isRegistering;

      if (!isAuthenticated && !isAuthScreen) {
        return '/login';
      }

      if (isAuthenticated && isAuthScreen) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'services',
        builder: (context, state) => const ServiceSelectionScreen(),
      ),
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) {
          final service = state.extra as ServiceModel;
          return BookingCalendarScreen(service: service);
        },
      ),
      GoRoute(
        path: '/my-appointments',
        builder: (context, state) => const MyAppointmentsScreen(),
      ),
    ],
  );
});