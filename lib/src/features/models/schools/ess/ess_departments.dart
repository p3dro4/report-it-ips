enum ESSDepartments {
  df,
  de,
  dcb,
  dccl,
}

extension ESSDepartmentsExtension on ESSDepartments {
  String get shortName {
    return switch (this) {
      ESSDepartments.df => "DF",
      ESSDepartments.de => "DE",
      ESSDepartments.dcb => "DCB",
      ESSDepartments.dccl => "DCCL",
    };
  }

  String get fullName {
    return switch(this){
      ESSDepartments.df => "Departamento de Fisioterapia",
      ESSDepartments.de => "Departamento de Enfermagem",
      ESSDepartments.dcb => "Departamento de Ciências Biomédicas",
      ESSDepartments.dccl => "Departamento de Ciências da Comunicação e da Linguagem",
    };
  }
}
