enum ESEDepartments {
  art,
  ccl,
  ct,
  csp,
}

extension ESEDepartmentsExtension on ESEDepartments {
  String get shortName {
    return switch (this) {
      ESEDepartments.art => "ART",
      ESEDepartments.ccl => "CCL",
      ESEDepartments.ct => "CT",
      ESEDepartments.csp => "CSP",
    };
  }

  String get fullName {
    return switch (this) {
      ESEDepartments.art => "Artes",
      ESEDepartments.ccl => "Ciências da Comunicação e da Linguagem",
      ESEDepartments.ct => "Ciências e Tecnologias",
      ESEDepartments.csp => "Ciências Sociais e Pedagogia"
    };
  }
}
