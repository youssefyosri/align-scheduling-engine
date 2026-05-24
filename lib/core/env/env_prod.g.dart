// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_prod.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.prod
final class _EnvProd {
  static const String apiUrl = 'your_api_url_here';

  static const List<int> _enviedkeystripePublishableKey = <int>[
    361980400,
    4040818667,
    2659822889,
    4005266023,
    2958413087,
    4284549463,
    732274646,
    1206106011,
    3289076590,
    3054180131,
    1490948224,
    459221139,
    1035557884,
    3978154181,
    1725305621,
    880974071,
    3089746370,
    441481695,
    2120286791,
    4174836673,
  ];

  static const List<int> _envieddatastripePublishableKey = <int>[
    361980297,
    4040818564,
    2659822940,
    4005265941,
    2958413120,
    4284549412,
    732274594,
    1206106089,
    3289076487,
    3054180179,
    1490948325,
    459221196,
    1035557783,
    3978154144,
    1725305708,
    880973992,
    3089746346,
    441481658,
    2120286773,
    4174836644,
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
