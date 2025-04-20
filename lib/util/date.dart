import 'package:intl/intl.dart';

String getCurrentDateTime() {
  return DateFormat('الوقت والتاريخ: yyyy-MM-dd HH:mm').format(DateTime.now());
}
