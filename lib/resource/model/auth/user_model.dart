class UserModel {
  String? maDangNhap;
  String? tenNguoiDung;
  String? matKhau;
  String? maTinh;
  String? maPBCC;
  String? diaChi;
  String? sDT;
  String? ghiChu;
  String? ngayCapNhat;
  bool? active;
  List<dynamic>? nNDIBKHo;
  List<dynamic>? nNDIBKThon;
  List<dynamic>? nNPhieuSo02;
  List<dynamic>? nNPhieuSo03;
  List<dynamic>? nNPhieuSo05;
  List<dynamic>? nNPhieuSo06;
  List<dynamic>? nNQLPhienBanDuLieu;

  String? ftpPublicUrl;
  String? ftpInternalUrl;
  String? ftpUserName;
  String? ftpPassword;

  UserModel({
    this.maDangNhap,
    this.tenNguoiDung,
    this.matKhau,
    this.maTinh,
    this.maPBCC,
    this.diaChi,
    this.sDT,
    this.ghiChu,
    this.ngayCapNhat,
    this.active,
    this.nNDIBKHo,
    this.nNDIBKThon,
    this.nNPhieuSo02,
    this.nNPhieuSo03,
    this.nNPhieuSo05,
    this.nNPhieuSo06,
    this.nNQLPhienBanDuLieu,
    this.ftpPublicUrl,
    this.ftpInternalUrl,
    this.ftpUserName,
    this.ftpPassword,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    maDangNhap = json['MaDangNhap'];
    tenNguoiDung = json['TenNguoiDung'];
    matKhau = json['MatKhau'];
    maTinh = json['MaTinh'];
    maPBCC = json['MaPBCC'];
    diaChi = json['DiaChi'];
    sDT = json['SDT'];
    ghiChu = json['GhiChu'];
    ngayCapNhat = json['NgayCapNhat'];
    active = json['Active'];

    ftpPublicUrl = json['FtpPublicUrl'];
    ftpInternalUrl = json['FtpInternalUrl'];
    ftpUserName = json['FtpUserName'];
    ftpPassword = json['FtpPassword'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['MaDangNhap'] = maDangNhap;
    data['TenNguoiDung'] = tenNguoiDung;
    data['MatKhau'] = matKhau;
    data['MaTinh'] = maTinh;
    data['MaPBCC'] = maPBCC;
    data['DiaChi'] = diaChi;
    data['SDT'] = sDT;
    data['GhiChu'] = ghiChu;
    data['NgayCapNhat'] = ngayCapNhat;
    data['Active'] = active;

    data['FtpPublicUrl'] = ftpPublicUrl;
    data['FtpInternalUrl'] = ftpInternalUrl;
    data['FtpUserName'] = ftpUserName;
    data['FtpPassword'] = ftpPassword;

    return data;
  }
}

class UserPwdModel {
  String? maDangNhap;
  String? matKhauHienTai;
  String? matKhau;
  String? maTinh;
  String? signature;

  UserPwdModel(
      {this.maDangNhap,
      this.matKhauHienTai,
      this.matKhau,
      this.maTinh,
      this.signature});

  UserPwdModel.fromJson(Map<String, dynamic> json) {
    maDangNhap = json['MaDangNhap'];
    matKhauHienTai = json['MatKhauHienTai'];
    matKhau = json['MatKhau'];
    maTinh = json['MaTinh'];
    signature = json['Signature'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['MaDangNhap'] = maDangNhap;
    data['MatKhauHienTai'] = matKhauHienTai;
    data['MatKhau'] = matKhau;
    data['MaTinh'] = maTinh;
    data['Signature'] = signature;
    return data;
  }
}