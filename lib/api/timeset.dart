import 'package:intl/intl.dart';

timeSet(String time) {
  var dateValue =
      new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(time).toLocal();
  String formattedDate = DateFormat("yyyy-MM-dd HH:mm").format(dateValue);
  return formattedDate;
}

getDate(String time, String type){
  var dateValue =
  new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(time).toLocal();
  switch(type){
    case 'MONTH' :
      return DateFormat("M").format(dateValue);
      break;
    case 'DAY' :
      return DateFormat("D").format(dateValue);
      break;
    case 'DATE' :
      return DateFormat("Md").format(dateValue);
      break;
  }
}
