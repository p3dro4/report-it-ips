enum ESTSDepartments {
  dee,
  dem,
  dmat,
  dsi,
  secec,
}

extension ESTSDepartmentsExtension on ESTSDepartments {
  String get shortName {
    switch (this) {
      case ESTSDepartments.dee:
        return 'DEE';
      case ESTSDepartments.dem:
        return 'DEM';
      case ESTSDepartments.dmat:
        return 'DMAT';
      case ESTSDepartments.dsi:
        return 'DSI';
      case ESTSDepartments.secec:
        return 'SeCEC';
    }
  }

  String get fullName {
    switch (this) {
      case ESTSDepartments.dee:
        return 'Departamento de Engenharia Electrotécnica e de Computadores';
      case ESTSDepartments.dem:
        return 'Departamento de Engenharia Mecânica';
      case ESTSDepartments.dmat:
        return 'Departamento de Matemática';
      case ESTSDepartments.dsi:
        return 'Departamento de Sistemas e Informática';
      case ESTSDepartments.secec:
        return 'Secção Autónoma de Ciências Empresariais e de Comunicação';
    }
  }
}
