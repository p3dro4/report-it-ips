enum ESSCourses {
  la,
  le,
  lf,
  ltf,
  lbi,
  me,
  mee,
  mfcme,
  mghsbe,
  mpafn,
  mtf,
  meb
}

extension ESSCoursesExtension on ESSCourses {
  String get shortName {
    return switch (this) {
      ESSCourses.la => "LA",
      ESSCourses.le => "LE",
      ESSCourses.lf => "LF",
      ESSCourses.ltf => "LTF",
      ESSCourses.lbi => "LBI",
      ESSCourses.me => "ME",
      ESSCourses.mee => "MEE",
      ESSCourses.mfcme => "MFCME",
      ESSCourses.mghsbe => "MGHSBE",
      ESSCourses.mpafn => "MPAFN",
      ESSCourses.mtf => "MTF",
      ESSCourses.meb => "MEB",
    };
  }

  String get fullName {
    return switch (this) {
      ESSCourses.la => "Licenciatura em Acupuntura",
      ESSCourses.le => "Licenciatura em Enfermagem",
      ESSCourses.lf => "Licenciatura em Fisioterapia",
      ESSCourses.ltf => "Licenciatura em Terapia da Fala",
      ESSCourses.lbi => "Licenciatura em Bioinformática",
      ESSCourses.me => "Mestrado em Enfermagem",
      ESSCourses.mee => "Mestrado em Estudos em Enfermagem",
      ESSCourses.mfcme =>
        "Mestrado em Fisioterapia em Condições Músculo-Esqueléticas",
      ESSCourses.mghsbe => "Mestrado Gestão em Hotelaria de Saúde e Bem-Estar",
      ESSCourses.mpafn =>
        "Mestrado em Práticas Avançadas de Fisioterapia em Neurologia",
      ESSCourses.mtf => "Mestrado em Terapia da Fala",
      ESSCourses.meb => "Mesrtrado em Engenharia Biomédica",
    };
  }
}
