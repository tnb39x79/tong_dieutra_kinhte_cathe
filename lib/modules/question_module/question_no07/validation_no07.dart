import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';

class ValidateQuestionNo07 {
  static onValidateInputA6_1(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi) {
    if (valueInput == null || valueInput == '' || valueInput == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    
  }
  static onValidateInputA6_8(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi) {
    if (valueInput == null || valueInput == '' || valueInput == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    
  }
  static String? onValidate(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi) {
    if (valueInput == null || valueInput == "" || valueInput == "null") {
      if (loaiCauHoi == AppDefine.loaiCauHoi_1 ||
          loaiCauHoi == AppDefine.loaiCauHoi_5) {
        return 'Vui lòng chọn giá trị.';
      }
      return 'Vui lòng nhập giá trị.';
    }
    if (maCauHoi == "A1_5_3") {
      //nam sinh
      if (valueInput.length != 4) {
        return 'Vui lòng nhập năm sinh 4 chũ số';
      }
      int namSinh = AppUtils.convertStringToInt(valueInput);
      if (namSinh < 1930 || namSinh > 2007) {
        return "Năm sinh phải nằm trong khoản 1930 - 2010";
      }
    }
  }
}
