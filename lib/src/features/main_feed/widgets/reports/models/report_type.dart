enum ReportType {
  priority,
  warning,
  info,
}

extension ReportTypeExtension on ReportType {
  String get name {
    switch (this) {
      case ReportType.priority:
        return 'PRIORITY';
      case ReportType.warning:
        return 'WARNING';
      case ReportType.info:
        return 'INFORMATION';
      default:
        return '';
    }
  }
}
