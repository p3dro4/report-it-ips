enum ReportTag {
  exterior,
  ese,
  ess,
  ests,
  esce,
  general,
}

extension ReportTagExtension on ReportTag {
  String get shortName {
    return switch (this) {
      ReportTag.exterior => 'EXTERIOR',
      ReportTag.ese => 'ESE',
      ReportTag.ess => 'ESS',
      ReportTag.ests => 'ESTS',
      ReportTag.esce => 'ESCE',
      ReportTag.general => 'GENERAL',
    };
  }

  int get color {
    return switch (this) {
      ReportTag.exterior => 0xFF857C7C,
      ReportTag.ese => 0xFFD12420,
      ReportTag.ess => 0xFFFDB924,
      ReportTag.ests => 0xFF4991CE,
      ReportTag.esce => 0xFFA6CE39,
      ReportTag.general => 0xFFFFFFFF,
    };
  }
}
