import 'package:get_storage/get_storage.dart';

class AppPref {
  AppPref._();

  static const String storageName = 'AppPref';

  static const String tokenKey = 'accessTokenKey';

  static const String uidKey = 'uid';
  static const String lastestDateTimeKey = 'lateDateTimeKey';
  static const String installKey = 'isFirstInstallKey';
  static const String userDataKey = 'userDataKey';
  static const String loginDataKey = 'loginDataKey';
  static const String savedNhomNganhKey =
      'savedNhomNganhKey'; // => check insert success
  static const String extraTokenKey =
      'extraTokenKey'; // => check branch C8 insert success
  static const String userNameKey = 'userNameKey';
  static const String passwordKey = 'passwordKey';

  static const String currentVersionKey = 'currentVersionKey';
  static const String countSynced = 'countSyncedKey';

  ///added by tuannb 23/07/2024: Lưu năm của kỳ điều tra để so sánh kiểm tra
  static const String yearKey = 'yearKey';

  ///added by tuannb 16/07/2024 Lưu ngày bắt đầu khi phỏng vấn
  static const String questionNoStartTimeKey = 'questionNoStartTimeKey';

  ///added by tuannb 23/07/2024 Lưu giá trị đã kiểm tra kỳ điều tra
  static const String checkedKdtKey = 'checkedKdtKey';
  static const String isLayDuLieuPVKey = 'isLayDuLieuPVKey';

  ///Ngày kết thúc điều tra;
  static const String ngayKetThucKey = 'ngayKetThucKey';

  ///Xác nhận kết thúc
  static const String xacNhanKetThucKey = 'xacNhanKetThucKey';

  ///Xoá dư liêuj
  static const String xoaDuLieuKey = 'xoaDuLieuKey';

  ///Ngày đăng nhập gần nhất
  static const String lastLoginDateKey = 'lastLoginDateKey';

  ///Số ngày hết hạn dăng nhập
  static const String soNgayHetHanDangNhapKey = 'soNgayHetHanDangNhapKey';

  ///Số ngày ngày hiện tại - ngày kết thúc điều tra
  static const String soNgayChoPhepXoaDuLieuKey = 'soNgayChoPhepXoaDuLieuKey';

  ///Versioin danh mục đang sử dụng ở capi
  static const String versionDanhMucKey = 'versionDanhMucKey';

  ///Link search vcpa AI
  static const String suggestionVcpaUrlKey = 'suggestionVcpaUrlKey';

  ///
  static const String dataModelAIFilePathKey = 'dataModelAIFilePathKey';

  ///Phiên bản model đang sử dụng. Ví dụ Tên file: model_v3.onnx
  static const String dataModelAIVersionFileNameKey =
      'dataModelAIVersionFileNameKey';
  static const String dataModelDownResultKey = 'dataModelDownResultKey';

  static final GetStorage _box = GetStorage(storageName);

  static initListener() async {
    await GetStorage.init(storageName);
  }

  static clear() async {
    await _box.remove(tokenKey);
    // await _box.remove(lateDateTime);  -> wait for create DB
    await _box.remove(uidKey);
    await _box.remove(userDataKey);
    await _box.remove(loginDataKey);
    await _box.remove(extraTokenKey);
    await _box.remove(userNameKey);
    await _box.remove(passwordKey);

    await _box.remove(countSynced);
    await _box.remove(currentVersionKey);
    //added by tuannb 16/07/2024
    await _box.remove(questionNoStartTimeKey);
    await _box.remove(yearKey);
    await _box.remove(ngayKetThucKey);
    await _box.remove(xacNhanKetThucKey);
    await _box.remove(xoaDuLieuKey);
    await _box.remove(lastLoginDateKey);
    await _box.remove(soNgayHetHanDangNhapKey);
    await _box.remove(soNgayChoPhepXoaDuLieuKey);
  }

  // user name
  static set userName(String? token) => _box.write(userNameKey, token);
  static String get userName => _box.read(userNameKey);

  // password
  static set password(String? token) => _box.write(passwordKey, token);
  static String get password => _box.read(passwordKey);

  // access token
  static set accessToken(String? token) => _box.write(tokenKey, token);
  static String? get accessToken => _box.read(tokenKey);

  // uid
  static set uid(String? uid) => _box.write(uidKey, uid);
  static String? get uid => _box.read(uidKey);

  // new version database
  static set dateTimeSaveDB(String? dateTime) =>
      _box.write(lastestDateTimeKey, dateTime);
  static String? get dateTimeSaveDB => _box.read(lastestDateTimeKey);

  // if user install first app then isFistInstall= 1
  static set isFistInstall(int? token) => _box.write(installKey, token);
  static int get isFistInstall => _box.read(installKey) ?? 0;

  // response login
  static set loginData(String? data) => _box.write(loginDataKey, data);
  static String get loginData => _box.read(loginDataKey) ?? '';

  //response get me
  static set userData(String? data) => _box.write(userDataKey, data);
  static String get userData => _box.read(userDataKey) ?? '';

  //Đã Lưu nhóm ngành
  static set savedNhomNganhVcpa(data) => _box.write(savedNhomNganhKey, data);
  static bool get savedNhomNganhVcpa => _box.read(savedNhomNganhKey) ?? false;

  // access token
  static set extraToken(String? token) => _box.write(extraTokenKey, token);
  static String? get extraToken => _box.read(extraTokenKey);

  static set currentVersion(String? version) =>
      _box.write(currentVersionKey, version);
  static String get currentVersion => _box.read(currentVersionKey) ?? '';

  ///added by tuannb 23/07/2024: Lưu năm của kỳ điều tra để so sánh kiểm tra
  static set yearKdt(int? yearKdt) => _box.write(yearKey, yearKdt);
  static int get yearKdt => _box.read(yearKey) ?? 0;

  ///added by tuannb 24/07/2024: Lưu giá trị đã kiểm tra kỳ điều tra: 1 đã kiểm tra; 0: chưa kiểm tra
  static set setCheckedKdtKey(int? checkedKdtKey1) =>
      _box.write(checkedKdtKey, checkedKdtKey1);
  static int get getCheckedKdtKey => _box.read(checkedKdtKey) ?? 0;

  //added by tuannb 16/07/2024
  static set setQuestionNoStartTime(String startTime) =>
      _box.write(questionNoStartTimeKey, startTime);
  static String get getQuestionNoStartTime =>
      _box.read(questionNoStartTimeKey) ?? '';

  static set ngayKetThucDT(String ngayKetThuc) =>
      _box.write(ngayKetThucKey, ngayKetThuc);

  ///Ngày kết thúc điều tra
  static String get ngayKetThucDT => _box.read(ngayKetThucKey) ?? '';

  static set xacNhanKetThucDT(String xacNhanKetThuc) =>
      _box.write(xacNhanKetThucKey, xacNhanKetThuc);

  ///Xác nhận kết thúc điều tra: 1 - Kết thúc; 0 - Chưa kết thúc
  static String get xacNhanKetThucDT => _box.read(xacNhanKetThucKey) ?? '';

  ///0: Không xoá (trường hợp trường XoaDuLieu ở bảng QL_TrangThaiDuLieu =0 )
  ///1: Được phép xoá (trường hợp trường XoaDuLieu ở bảng QL_TrangThaiDuLieu =1)
  ///2: Đã thực hiện xoá dữ liệu (ko nằm trong giá trị của bảng QL_TrangThaiDuLieu);
  static set xoaDuLieuDT(String xoaDuLieu) =>
      _box.write(xoaDuLieuKey, xoaDuLieu);
  static String get xoaDuLieuDT => _box.read(xoaDuLieuKey) ?? '';

  static set lastLoginDate(String lldate) =>
      _box.write(lastLoginDateKey, lldate);

  ///Ngày đăng nhập gần nhất
  static String get lastLoginDate => _box.read(lastLoginDateKey) ?? '';

  static set soNgayHetHanDangNhap(String soNgay) =>
      _box.write(soNgayHetHanDangNhapKey, soNgay);

  ///Số ngày hết hạn đăng nhập.
  static String get soNgayHetHanDangNhap =>
      _box.read(soNgayHetHanDangNhapKey) ?? '';

  static set soNgayChoPhepXoaDuLieu(String soNgay) =>
      _box.write(soNgayChoPhepXoaDuLieuKey, soNgay);
  static String get soNgayChoPhepXoaDuLieu =>
      _box.read(soNgayChoPhepXoaDuLieuKey) ?? '';

  static set versionDanhMuc(String soNgay) =>
      _box.write(versionDanhMucKey, soNgay);
  static String get versionDanhMuc => _box.read(versionDanhMucKey) ?? '';

  static set suggestionVcpaUrl(String soNgay) =>
      _box.write(suggestionVcpaUrlKey, soNgay);
  static String get suggestionVcpaUrl => _box.read(suggestionVcpaUrlKey) ?? '';

    static set dataModelAIFilePath(String filePath) =>
      _box.write(dataModelAIFilePathKey, filePath);
  static String get dataModelAIFilePath =>
      _box.read(dataModelAIFilePathKey) ?? '';

  static set dataModelAIVersionFileName(String fileName) =>
      _box.write(dataModelAIVersionFileNameKey, fileName);
  static String get dataModelAIVersionFileName =>
      _box.read(dataModelAIVersionFileNameKey) ?? '';

  static set dataModelDownResult(String downloadResult) =>
      _box.write(dataModelDownResultKey, downloadResult);
  static String get dataModelDownResult =>
      _box.read(dataModelDownResultKey) ?? '';
}
