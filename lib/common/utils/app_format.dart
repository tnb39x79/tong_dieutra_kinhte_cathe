import 'package:intl/intl.dart';

class AppFormat {
  AppFormat._();

  static String dateTimeToString(String? date, {String formart = 'dd/MM/yyy'}) {
    DateTime now = DateTime.now();
    if (date == null) {
      return '';
    }
    String formattedDate = DateFormat(formart).format(now);
    return formattedDate;
  }
}
