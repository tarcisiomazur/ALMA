class Format{

  static String DurationToAge(Duration duration){
    String builder = "";
    int years = duration.inDays~/365;
    if(years > 1){
      builder += "$years anos ";
    }else if(years == 1){
      builder += "1 ano ";
    }
    int months = (duration.inDays-years*365)~/30;
    if(months > 1){
      builder += "$months meses";
    }else if(months == 1){
      builder += "1 mês";
    }
    if(builder==''){
      if(duration.inDays > 0){
        builder += "$duration.inDays dias";
      }else if(duration.isNegative){
        builder += "Veio do futuro";
      }else{
        builder += "Recém Nascido";
      }
    }
    return builder;
  }
}