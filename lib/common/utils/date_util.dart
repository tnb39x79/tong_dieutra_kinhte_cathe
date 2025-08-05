import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  DateTimeUtil._();

  static toDayMonthYearString(
      {String dateString = "2021-06-24T06:38:50.794Z"}) {
    initializeDateFormatting("vi_VN", null);
    var date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  static toDayMonthYearDate(DateTime date) {
    initializeDateFormatting("vi_VN", null);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  static toMonthYearDate(DateTime date) {
    initializeDateFormatting("vi_VN", null);
    final DateFormat formatter = DateFormat('MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  static toMonthDayYearTime({String dateString = "2021-06-24T06:38:50.794Z"}) {
    initializeDateFormatting("vi_VN", null);
    var date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('HH:mm - dd/MM/yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }
}
