import 'dart:math';

class AppUtils {
  AppUtils._();
  AppUtils();

   

  static convertStringToDouble(value) {
    if (value == null || value == "" || value == "null") {
      return 0.0;
    }
    return double.parse(value.toString().replaceAll(",", "."));
  }

  static doubleToFixed(double? value, int fractionDigits) {
    try {
      if (value == null) {
        return 0.0;
      }
      return value.toStringAsFixed(fractionDigits);
    } catch (e) {
      return value;
    }
  }

  static dynamicToFixed(value, int fractionDigits) {
    try {
      if (value == null) {
        return 0;
      }
      return double.parse(value.toString()).toStringAsFixed(fractionDigits);
    } catch (e) {
      return value;
    }
  }

  static convertStringAndFixedToDouble(value) {
    if (value == null || value == "" || value == "null") {
      return 0.00;
    }
    try {
      var res = double.parse(value.toString().replaceAll(",", "."));
      return double.parse(res.toStringAsFixed(2));
    } catch (e) {
      return value ?? double.parse(value.toString().replaceAll(",", "."));
    }
  }

  static convertStringAndFixed2ToString(value) {
    if (value == null || value == "" || value == "null") {
      return '';
    }
    try {
      var res = double.parse(value.toString().replaceAll(",", "."));
      return res.toStringAsFixed(2);
    } catch (e) {
      return value ?? value.toString().replaceAll(",", ".");
    }
  }

  static int convertStringToInt(value) {
    if (value == null || value == "" || value == "null") {
      return 0;
    }
    return int.parse(value.toString());
  }

  static getTextKhoangGiaTri(minValue, maxValue) {
    var kgt =
        '${AppUtils.dynamicToFixed(minValue, 0)} - ${AppUtils.dynamicToFixed(maxValue, 0)}';
    return kgt;
  }

  String getCustomUniqueId() {
    const String pushChars =
        '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
    int lastPushTime = 0;
    List lastRandChars = [];
    int now = DateTime.now().millisecondsSinceEpoch;
    bool duplicateTime = (now == lastPushTime);
    lastPushTime = now;
    List timeStampChars = List<String>.filled(8, '0');
    for (int i = 7; i >= 0; i--) {
      timeStampChars[i] = pushChars[now % 64];
      now = (now / 64).floor();
    }
    if (now != 0) {
      print("Id should be unique");
    }
    String uniqueId = timeStampChars.join('');
    if (!duplicateTime) {
      for (int i = 0; i < 12; i++) {
        lastRandChars.add((Random().nextDouble() * 64).floor());
      }
    } else {
      int i = 0;
      for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
        lastRandChars[i] = 0;
      }
      lastRandChars[i]++;
    }
    for (int i = 0; i < 12; i++) {
      uniqueId += pushChars[lastRandChars[i]];
    }
    return uniqueId;
  }

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
