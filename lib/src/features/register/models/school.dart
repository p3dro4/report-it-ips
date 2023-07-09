enum School {
  ests,
  ese,
  ess,
  esce,
}

extension SchoolExtension on School {
  String get name {
    switch (this) {
      case School.ests:
        return 'ESTS';
      case School.ese:
        return 'ESE';
      case School.ess:
        return 'ESS';
      case School.esce:
        return 'ESCE';
    }
  }

  String get fullName {
    switch (this) {
      case School.ests:
        return 'Escola Superior de Tecnologia de Setúbal';
      case School.ese:
        return 'Escola Superior de Educação';
      case School.ess:
        return 'Escola Superior de Saúde';
      case School.esce:
        return 'Escola Superior de Ciências Empresariais';
    }
  }
}
