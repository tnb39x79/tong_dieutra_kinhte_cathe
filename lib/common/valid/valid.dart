import 'package:gov_statistics_investigation_economic/common/utils/app_regex.dart';

class Valid {
  Valid._();

  static String? validateUserName(String? userName) {
    if (userName == null || userName.trim().isEmpty) {
      return 'Vui lòng nhập tên đăng nhập.';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    RegExp regExp = RegExp(AppRegex.regexPhoneNumber);
    if (phoneNumber != null) {
      if (!regExp.hasMatch(phoneNumber)) {
        return 'Số điện thoại không hợp lên';
      }
      return null;
    }
    return 'Vui lòng nhập số điện thoại.';
  }

  static String? validateMobile(String? value) {
    String pattern = r'(^(0)[0-9]{9,10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    } else if (!regExp.hasMatch(value)) {
      return 'Vui lòng nhập đúng số điện thoại';
    }
    return null;
  }

  static String? validatePhoneAndName(
      String? phone, String? name, String? phoneDtv, String? nameDtv) {
    if (name == null ||
        name.trim().isEmpty ||
        nameDtv == null ||
        nameDtv.trim().isEmpty) {
      return 'Vui lòng nhập tên người trả lời';
    }
    String? phoneValidation = validateMobile(phone);
    //  String? phoneValidationDtv = validateMobile(phoneDtv);
    if (phoneValidation != null && phoneValidation != '') {
      return phoneValidation;
    }
    // if (phoneValidationDtv != null && phoneValidationDtv != '') {
    //   return phoneValidationDtv;
    // }
    return null;
  }

  static String? validateEmail(String? email) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (email != null && email != '') {
      return !regex.hasMatch(email) ? 'Địa chỉ email không hợp lệ.' : null;
    }

    return null;
  }

  static String? hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Địa chỉ truy cập không h';
    }
    return null;
  }
}
