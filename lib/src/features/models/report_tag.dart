import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ReportTag {
  general,
  exterior,
  ese,
  ess,
  ests,
  esce,
}

extension ReportTagExtension on ReportTag {
  String get shortName {
    return switch (this) {
      ReportTag.general => 'GENERAL',
      ReportTag.exterior => 'EXTERIOR',
      ReportTag.ese => 'ESE',
      ReportTag.ess => 'ESS',
      ReportTag.ests => 'ESTS',
      ReportTag.esce => 'ESCE',
    };
  }

  int get color {
    return switch (this) {
      ReportTag.exterior => 0xFF857C7C,
      ReportTag.ese => 0xFFD12420,
      ReportTag.ess => 0xFFFDB924,
      ReportTag.ests => 0xFF4991CE,
      ReportTag.esce => 0xFFA6CE39,
      ReportTag.general => 0xFF000000,
    };
  }

  String getNameWithContext(BuildContext context) {
    return switch (this) {
      ReportTag.general => L.of(context)!.general.toUpperCase(),
      _ => shortName,
    };
  }
}
