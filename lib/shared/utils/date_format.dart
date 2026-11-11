import 'package:intl/intl.dart';

abstract final class AppDateFormat {
  static String formatShortDate(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String formatTime(DateTime date, String locale) {
    return DateFormat.Hm(locale).format(date);
  }
}
