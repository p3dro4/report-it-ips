enum ESCECourses {
  lcf,
  lgdl,
  lgrh,
  lgsi,
  lm,
  mce,
  mcde,
  mcf,
  mgae,
  mgerh,
  mghsbe,
  mgm,
  msi,
  mlgca,
  msht,
}

extension ESCECoursesExtension on ESCECourses {
  String get name {
    return switch (this) {
      ESCECourses.lcf => "LCF",
      ESCECourses.lgdl => "LGDL",
      ESCECourses.lgrh => "LGRH",
      ESCECourses.lgsi => "LGSi",
      ESCECourses.lm => "LM",
      ESCECourses.mce => "MCE",
      ESCECourses.mcde => "MCDE",
      ESCECourses.mcf => "MCF",
      ESCECourses.mgae => "MGAE",
      ESCECourses.mgerh => "MGERH",
      ESCECourses.mghsbe => "MGHSBE",
      ESCECourses.mgm => "MGM",
      ESCECourses.msi => "MSI",
      ESCECourses.mlgca => "MLGCA",
      ESCECourses.msht => "MSHT",
    };
  }

  String get fullName {
    return switch (this) {
      ESCECourses.lcf => "Licenciatura em Contabilidade e Finanças",
      ESCECourses.lgdl => "Licenciatura em Gestão de Distribuição e Logística",
      ESCECourses.lgrh => "Licenciatura em Gestão de Recursos Humanos",
      ESCECourses.lgsi => "Licenciatura em Gestão de Sistemas de Informação",
      ESCECourses.lm => "Licenciatura em Marketing",
      ESCECourses.mce => "Mestrado em Ciências Empresariais",
      ESCECourses.mcde => "Mestrado em Ciências de Dados para Empresas",
      ESCECourses.mcf => "Mestrado em Contabilidade e Finanças",
      ESCECourses.mgae => "Mestrado em Gestão e Administração de Escolas",
      ESCECourses.mgerh => "Mestrado em Gestão Estratégica de Recursos Humanos",
      ESCECourses.mghsbe =>
        "Mestrado em Gestão em Hotelaria de Saúde e Bem-Estar",
      ESCECourses.mgm => "Mestrado em Gestão de Marketing",
      ESCECourses.msi => "Mestrado em Gestão de Sistemas de Informação",
      ESCECourses.mlgca =>
        "Mestrado em Logística e Gestão da Cadeia de Abastecimento",
      ESCECourses.msht => "Mestrado em Segurança e Higiene no Trabalho",
    };
  }
}
