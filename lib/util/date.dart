import 'package:intl/intl.dart';

String getCurrentDateTime() {
  final now = DateTime.now();

  final year = NumberFormat('0000', 'en').format(now.year);
  final month = NumberFormat('00', 'en').format(now.month);
  final day = NumberFormat('00', 'en').format(now.day);
  final hour = NumberFormat('00', 'en').format(now.hour);
  final minute = NumberFormat('00', 'en').format(now.minute);

  return 'الوقت والتاريخ: $year-$month-$day $hour:$minute';
}
