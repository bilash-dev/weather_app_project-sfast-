import 'package:intl/intl.dart';

String getFormattedDate(num dt, String format){
  return DateFormat().format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));
}