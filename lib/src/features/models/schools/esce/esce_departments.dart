enum ESCEDepartments {
  drh,
  dcf,
  deg,
  dml,
  dsi,
}

extension ESCEDepartmentsExtension on ESCEDepartments {
  String get shortName {
    return switch (this) {
      ESCEDepartments.drh => "DRH",
      ESCEDepartments.dcf => "DCF",
      ESCEDepartments.deg => "DEG",
      ESCEDepartments.dml => "DML",
      ESCEDepartments.dsi => "DSI",
    };
  }

  String get fullName {
    return switch (this) {
      ESCEDepartments.drh =>
        "Departamento de Comportamento Organizacional e Gestão de Recursos Humanos",
      ESCEDepartments.dcf => "Departamento de Ciências da Formação",
      ESCEDepartments.deg => "Departamento de Economia e Gestão",
      ESCEDepartments.dml => "Departamento de Marketing e Logística",
      ESCEDepartments.dsi => "Departamento de Sistemas de Informação",
    };
  }
}
