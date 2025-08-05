class TokenModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  String? clientId;
  String? userName;
  String? issued;
  String? expires;
  String? cuocDieuTra;
  String? ngayKetThuc;
  String? xacNhanKetThuc;
  String? xoaDuLieu;
  String? soNgayHHDN;
  String? soNgayChoPhepXoaDL;
  String? soNgayDT;
  String? suggestionVcpaUrl;
  String? domainAPI;
  String? portAPI;

  String? ftpPublicUrl;
  String? ftpInternalUrl;
  String? ftpUserName;
  String? ftpPassword;

  TokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.clientId,
    this.userName,
    this.issued,
    this.expires,
    this.ftpPublicUrl,
    this.ftpInternalUrl,
    this.ftpUserName,
    this.ftpPassword,
    this.cuocDieuTra,
    this.ngayKetThuc,
    this.xacNhanKetThuc,
    this.xoaDuLieu,
    this.soNgayChoPhepXoaDL,
    this.soNgayHHDN,
    this.suggestionVcpaUrl,
    this.domainAPI,
    this.portAPI,
  });

  TokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    clientId = json['client_id'];
    userName = json['userName'];
    issued = json['.issued'];
    expires = json['.expires'];
    cuocDieuTra = json['CuocDieuTra'];
    ngayKetThuc = json['NgayKetThuc'];
    xacNhanKetThuc = json['XacNhanKetThuc'];
    xoaDuLieu = json['XoaDuLieu'];
    soNgayHHDN = json['SoNgayHHDN'];
    soNgayChoPhepXoaDL = json['SoNgayChoPhepXoaDL'];
    suggestionVcpaUrl = json['SuggestionVcpaUrl'];

    domainAPI = json['DomainAPI'];
    portAPI = json['PortAPI'];

    ftpPublicUrl = json['FtpPublicUrl'];
    ftpInternalUrl = json['FtpInternalUrl'];
    ftpUserName = json['FtpUserName'];
    ftpPassword = json['FtpPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    data['client_id'] = clientId;
    data['userName'] = userName;
    data['.issued'] = issued;
    data['.expires'] = expires;
    data['CuocDieuTra'] = cuocDieuTra;
    data['NgayKetThuc'] = ngayKetThuc;
    data['XacNhanKetThuc'] = xacNhanKetThuc;
    data['XoaDuLieu'] = xoaDuLieu;
    data['SoNgayHHDN'] = soNgayHHDN;
    data['SoNgayChoPhepXoaDL'] = soNgayChoPhepXoaDL;
    data['SuggestionVcpaUrl'] = suggestionVcpaUrl;
    data['FtpPublicUrl'] = ftpPublicUrl;
    data['FtpInternalUrl'] = ftpInternalUrl;
    data['FtpUserName'] = ftpUserName;
    data['FtpPassword'] = ftpPassword;
    data['DomainAPI'] = domainAPI;
    data['PortAPI'] = portAPI;

    return data;
  }
}
