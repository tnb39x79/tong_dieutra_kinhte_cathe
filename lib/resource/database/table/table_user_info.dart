///
///- Chứa thông tin user đăng nhập
const String tableUserInfo = 'UserInfo';
const String columnUserInfoId = '_id';
const String columnUserInfoMaDangNhap = 'MaDangNhap';
const String columnUserInfoTenNguoiDung = 'TenNguoiDung';
const String columnUserInfoMatKhau = 'MatKhau';
const String columnUserInfoMaTinh = 'MaTinh';
const String columnUserInfoMaPBCC = 'MaPBCC';
const String columnUserInfoDiaChi = 'DiaChi';
const String columnUserInfoSDT = 'SDT';
const String columnUserInfoGhiChu = 'GhiChu';
const String columnUserInfoNgayCapNhat = 'NgayCapNhat';
const String columnUserInfoActive = 'Active';
  
const String columnUserInfoCreatedAt = 'CreatedAt';
const String columnUserInfoUpdatedAt = 'UpdatedAt';
const String columnUserInfoIsSuccess = 'IsSuccess';

class TableUserInfo {
  int? id;
  String? maDangNhap;
  String? tenNguoiDung;
  String? matKhau;
  String? maTinh;
  String? maPBCC;
  String? diaChi;
  String? sdt;
  String? ghiChu;
  String? ngayCapNhat;
  int? active;
  String? createdAt;
  String? updatedAt;
  int? isSuccess; 

  TableUserInfo({
    this.id,
    this.maDangNhap,
    this.tenNguoiDung,
    this.matKhau,
    this.maTinh,
    this.maPBCC,
    this.diaChi,
    this.sdt,
    this.ghiChu,
    this.ngayCapNhat,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.isSuccess, 
  });

  TableUserInfo.fromJson(dynamic json) {
    id = json['_id'];
    maDangNhap = json['MaDangNhap'];
    tenNguoiDung = json['TenNguoiDung'];
    matKhau = json['MatKhau'];
    maTinh = json['MaTinh'];
    maPBCC = json['MaPBCC'];
    diaChi = json['DiaChi'];
    sdt = json['SDT'];
    ghiChu = json['GhiChu'];
    ngayCapNhat = json['NgayCapNhat'];
    active = json['Active']  
        ? json['Active'] == 1
            ? true
            : false
        : json['Active'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
   
    isSuccess = json['IsSuccess']  
        ? json['IsSuccess'] == 1
            ? true
            : false
        : json['IsSuccess'];
  }

  Map<String, Object?> toJson() {
    var map = <String, Object?>{};
    map['MaDangNhap'] = maDangNhap;
    map['TenNguoiDung'] = tenNguoiDung;
    map['MatKhau'] = matKhau;
    map['MaTinh'] = maTinh;
    map['MaPBCC'] = maPBCC;
    map['DiaChi'] = diaChi;
    map['SDT'] = sdt;
    map['GhiChu'] = ghiChu;
    map['NgayCapNhat'] = ngayCapNhat;
    map['Active'] = active;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    map['IsSuccess'] = isSuccess; 
    return map;
  } 
}
