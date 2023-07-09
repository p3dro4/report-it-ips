enum ESTSCourses {
  leec,
  leaci,
  lei,
  lem,
  ltb,
  lte,
  ltgi,
  ltam,
  lbi,
  ctespArci,
  ctespCe,
  ctespDvam,
  ctespMi,
  ctespPa,
  ctespPwdam,
  ctespQaa,
  ctespReid,
  ctespRsi,
  ctespSec,
  ctespTga,
  ctespTpsi,
  ctespTi,
  ctespVe,
  pgMveh,
  pgTa,
  meb,
  mep,
  mes,
  meec,
  megeie,
  msht
}

extension ESTSCoursesExtension on ESTSCourses {
  String get name {
    switch (this) {
      case ESTSCourses.leec:
        return 'LEEC';
      case ESTSCourses.leaci:
        return 'LEACI';
      case ESTSCourses.lei:
        return 'LEI';
      case ESTSCourses.lem:
        return 'LEM';
      case ESTSCourses.ltb:
        return 'LTB';
      case ESTSCourses.lte:
        return 'LTE';
      case ESTSCourses.ltgi:
        return 'LTGI';
      case ESTSCourses.ltam:
        return 'LTAM';
      case ESTSCourses.lbi:
        return 'LBI';
      case ESTSCourses.ctespArci:
        return 'CTeSP_ARCI';
      case ESTSCourses.ctespCe:
        return 'CTeSP_CE';
      case ESTSCourses.ctespDvam:
        return 'CTeSP_DVAM';
      case ESTSCourses.ctespMi:
        return 'CTeSP_MI';
      case ESTSCourses.ctespPa:
        return 'CTeSP_PA';
      case ESTSCourses.ctespPwdam:
        return 'CTeSP_PWDA';
      case ESTSCourses.ctespQaa:
        return 'CTeSP_QAA';
      case ESTSCourses.ctespReid:
        return 'CTeSP_REID';
      case ESTSCourses.ctespRsi:
        return 'CTeSP_RSI';
      case ESTSCourses.ctespSec:
        return 'CTeSP_SEC';
      case ESTSCourses.ctespTga:
        return 'CTeSP_TGA';
      case ESTSCourses.ctespTpsi:
        return 'CTeSP_TPSI';
      case ESTSCourses.ctespTi:
        return 'CTeSP_TI';
      case ESTSCourses.ctespVe:
        return 'CTeSP_VE';
      case ESTSCourses.pgMveh:
        return 'PG_MVEH';
      case ESTSCourses.pgTa:
        return 'PG_TA';
      case ESTSCourses.meb:
        return 'MEB';
      case ESTSCourses.mep:
        return 'MEP';
      case ESTSCourses.mes:
        return 'MES';
      case ESTSCourses.meec:
        return 'MEEC';
      case ESTSCourses.megeie:
        return 'MEGEIE';
      case ESTSCourses.msht:
        return 'MSHT';
    }
  }

  String get fullName {
    switch (this) {
      case ESTSCourses.leec:
        return 'Licenciatura em Engenharia Electrónica e de Computadores';
      case ESTSCourses.leaci:
        return 'Licenciatura em Engenharia de Automação e Controlo e Instrumentação';
      case ESTSCourses.lei:
        return 'Licenciatura em Engenharia Informática';
      case ESTSCourses.lem:
        return 'Licenciatura em Engenharia Mecânica';
      case ESTSCourses.ltb:
        return 'Licenciatura em Tecnologia Biomédica';
      case ESTSCourses.lte:
        return 'Licenciatura em Tecnologia de Energia';
      case ESTSCourses.ltgi:
        return 'Licenciatura em Tecnologia e Gestão Industrial';
      case ESTSCourses.ltam:
        return 'Licenciatura do Ambiente e do Mar';
      case ESTSCourses.lbi:
        return 'Licenciatura em Bioinformática';
      case ESTSCourses.ctespArci:
        return 'CTeSP em Automação, Robótica e Controlo Industrial';
      case ESTSCourses.ctespCe:
        return 'CTeSP em Climatização e Energia';
      case ESTSCourses.ctespDvam:
        return 'CTeSP em Desenvolvimento de Videojogos e Aplicações Multimédia';
      case ESTSCourses.ctespMi:
        return 'CTeSP em Manutenção Industrial';
      case ESTSCourses.ctespPa:
        return 'CTeSP em Produção Aeronaútica';
      case ESTSCourses.ctespPwdam:
        return 'CTeSP em Programação Web, Dispositivos e Aplicações Móveis';
      case ESTSCourses.ctespQaa:
        return 'CTeSP em Qualidade Ambiental e Alimentar';
      case ESTSCourses.ctespReid:
        return 'CTeSP em Redes Eléctricas Inteligentes e Domótica';
      case ESTSCourses.ctespRsi:
        return 'CTeSP em Redes e Sistemas Informáticos';
      case ESTSCourses.ctespSec:
        return 'CTeSP em Sistemas Electrónicos e Computadores';
      case ESTSCourses.ctespTga:
        return 'CTeSP em Tecnologia e Gestão Automóvel';
      case ESTSCourses.ctespTpsi:
        return 'CTeSP em Tecnologia e Programação de Sistemas de Informação';
      case ESTSCourses.ctespTi:
        return 'CTeSP em Tecnologias de Informáticas';
      case ESTSCourses.ctespVe:
        return 'CTeSP em Veículos Eléctricos';
      case ESTSCourses.pgMveh:
        return 'Pós-Graduação em Motorização de Veículos Eléctricos e Híbridos';
      case ESTSCourses.pgTa:
        return 'Pós-Graduação em Tecnologias Aeronáuticas';
      case ESTSCourses.meb:
        return 'Mestrado em Engenharia Biomédica';
      case ESTSCourses.mep:
        return 'Mestrado em Engenharia de Produção';
      case ESTSCourses.mes:
        return 'Mestrado em Engenharia de Software';
      case ESTSCourses.meec:
        return 'Mestrado em Engenharia Electrotécnica e de Computadores';
      case ESTSCourses.megeie:
        return 'Mestrado em Engenharia e Gestão de Energia na Indústria e Edifícios';
      case ESTSCourses.msht:
        return 'Mestrado em Segurança e Higiene no Trabalho';
    }
  }
}
