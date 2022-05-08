import 'package:intl/intl.dart';

const String KEYACCESSTOKEN = 'accessToken';
const String KEYREFRESHTOKEN = 'refreshToken';
const String KEYNICKNAME = 'nickname';
const String KEYNAME = 'name';
const String KEYEMAIL = 'email';
const String KEYPLATFORM = 'platform';
String KEYYEARS = 'years';
String KEYMONTH = "4"; // 매달 바뀌는 값이라 const가 안됨 주의
String KEYMONTHINFO = "4" + 'INFO';
String NOWYEAR= DateFormat.y().format(DateTime.now());
String Date = DateFormat.yMMMM().format(DateTime.now());
String NOWMONTH = DateFormat.M().format(DateTime.now());
//DateFormat.y().format(DateTime.now()) // 년도
//DateFormat.M().format(DateTime.now()) // 월 원래 들어가야할 것들
