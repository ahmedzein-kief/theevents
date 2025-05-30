import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static final DateFormat dayMonthYearFormat = DateFormat('dd MMM yyyy');

  String get formattedDayMonthYear => dayMonthYearFormat.format(this);
}
