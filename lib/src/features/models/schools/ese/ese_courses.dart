enum ESECourses {
  las,
  lcs,
  ldesp,
  leb,
  lgp,
  lanim,
  ctespDn,
  ctespPa,
  ctespPaa,
  ctespSfc,
  ctespAgo,
  ctespGt,
  mepai,
  mpe,
  mpe1c,
  memcn,
  mephgp,
  mgae,
}

extension EseCoursesExtension on ESECourses {
  String get shortName {
    return switch (this) {
      ESECourses.las => "LAS",
      ESECourses.lcs => "LCS",
      ESECourses.ldesp => "LDESP",
      ESECourses.leb => "LEB",
      ESECourses.lgp => "LGP",
      ESECourses.lanim => "LANIM",
      ESECourses.ctespDn => "CTeSP_DN",
      ESECourses.ctespPa => "CTeSP_PA",
      ESECourses.ctespPaa => "CTeSP_PAA",
      ESECourses.ctespSfc => "CTeSP_SFC",
      ESECourses.ctespAgo => "CTeSP_AGO",
      ESECourses.ctespGt => "CTeSP_GT",
      ESECourses.mepai => "MEPAI",
      ESECourses.mpe => "MPE",
      ESECourses.mpe1c => "MPE1C",
      ESECourses.memcn => "MEMCN",
      ESECourses.mephgp => "MEPHGP",
      ESECourses.mgae => "MGAE",
    };
  }

  String get fullName {
    return switch (this) {
      ESECourses.las => "Licenciatura em Animação Sociocultural",
      ESECourses.lcs => "Licenciatura em Comunicação Social",
      ESECourses.ldesp => "Licenciatura em Desporto",
      ESECourses.leb => "Licenciatura em Educação Básica",
      ESECourses.lgp =>
        "Licenciatura em Tradução e Interpretação de Língua Gestual Portuguesa",
      ESECourses.lanim =>
        "Licenciatura em Animação e Intervenção Sociocultural",
      ESECourses.ctespDn =>
        "Curso Técnico Superior Profissional em Desportos de Natureza",
      ESECourses.ctespPa =>
        "Curso Técnico Superior Profissional em Produção Audiovisual",
      ESECourses.ctespPaa =>
        "Curso Técnico Superior Profissional em Produção Audiovisual-AMADORA",
      ESECourses.ctespSfc =>
        "Curso Técnico Superior Profissional em Serviço Familiar e Comunitário",
      ESECourses.ctespAgo =>
        "Curso Técnico Superior Profissional em Apoio à Gestão de Organizações Sociais",
      ESECourses.ctespGt =>
        "Curso Técnico Superior Profissional em Gestão de Turismo",
      ESECourses.mepai =>
        "Mestrado em Educação, Práticas Artísticas e Inclusão",
      ESECourses.mpe => "Mestrado em Educação Pré-Escolar",
      ESECourses.mpe1c =>
        "Mestrado em Educação Pré-Escolar e Ensino do 1º ciclo do Ensino Básico",
      ESECourses.memcn =>
        "Mestrado em Ensino do 1º Ciclo do Ensino Básico e de Matemática e Ciências Naturais no 2º Ciclo do Ensino Básico",
      ESECourses.mephgp =>
        "Mestrado em Ensino do 1.º Ciclo do Ensino Básico e de Português e História e Geografia de Portugal no 2.º Ciclo do Ensino Básico",
      ESECourses.mgae => "Mestrado em Gestão e Administração de Escolas",
    };
  }
}
