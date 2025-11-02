class ProgressModel {
  int? maDoiTuongDT;
  String? tenDoiTuongDT;
  String? moTaDoiTuongDT;
  int? countTotal;
  int? countPhieuInterviewed;
  int? countPhieuUnInterviewed;
  int? countPhieuSyncSuccess;
  int? countPhieuUnSync;

  ProgressModel(
      {this.maDoiTuongDT,
      this.tenDoiTuongDT,
      this.moTaDoiTuongDT,
      this.countTotal,
      this.countPhieuInterviewed,
      this.countPhieuUnInterviewed,
      this.countPhieuSyncSuccess,
      this.countPhieuUnSync});

  ProgressModel.fromJson(Map json) {
    maDoiTuongDT = json['MaDoiTuongDT'];
    tenDoiTuongDT = json['TenDoiTuongDT'];
    moTaDoiTuongDT = json['MoTaDoiTuongDT'];
    countTotal = json['CountTotal'];
    countPhieuInterviewed = json['CountPhieuInterviewed'];
    countPhieuUnInterviewed = json['CountPhieuUnInterviewed'];
    countPhieuSyncSuccess = json['CountPhieuSyncSuccess'];
    countPhieuUnSync = json['CountPhieuUnSync'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaDoiTuongDT'] = maDoiTuongDT;
    data['TenDoiTuongDT'] = tenDoiTuongDT;
    data['MoTaDoiTuongDT'] = moTaDoiTuongDT;
    data['CountTotal'] = countTotal;
    data['CountPhieuInterviewed'] = countPhieuInterviewed;
    data['CountPhieuUnInterviewed'] = countPhieuUnInterviewed;
    data['CountPhieuSyncSuccess'] = countPhieuSyncSuccess;
    data['CountPhieuUnSync'] = countPhieuUnSync;
    return data;
  }

  static List<ProgressModel> listFromJson(dynamic localities) {
    List<ProgressModel> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(ProgressModel.fromJson(item));
      }
    }
    return list;
  }
}
