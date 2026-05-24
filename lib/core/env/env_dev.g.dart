// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_dev.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.dev
final class _EnvDev {
  static const String apiUrl = 'your_api_url_here';

  static const List<int> _enviedkeystripePublishableKey = <int>[
    3196503471,
    3794520267,
    1761656251,
    868931696,
    1530884916,
    1455959570,
    3703728201,
    2006483392,
    2967598264,
    2339446088,
    3300889791,
    1691912152,
    3209206344,
    853350528,
    3882852479,
    2631651120,
    3859592957,
    3876589679,
    3110588861,
    3829190189,
  ];

  static const List<int> _envieddatastripePublishableKey = <int>[
    3196503510,
    3794520228,
    1761656270,
    868931586,
    1530884971,
    1455959649,
    3703728189,
    2006483378,
    2967598289,
    2339446072,
    3300889818,
    1691912071,
    3209206307,
    853350629,
    3882852358,
    2631651183,
    3859592853,
    3876589578,
    3110588879,
    3829190216,
  ];

  static final String stripePublishableKey = String.fromCharCodes(
    List<int>.generate(
      _envieddatastripePublishableKey.length,
      (int i) => i,
      growable: false,
    ).map(
      (int i) =>
          _envieddatastripePublishableKey[i] ^
          _enviedkeystripePublishableKey[i],
    ),
  );
}
