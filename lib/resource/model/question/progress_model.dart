class ProgressModel {
  int? maDoiTuongDT;
  String? tenDoiTuongDT;
  String? moTaDoiTuongDT;
  int? countPhieuInterviewed;
  int? countPhieuUnInterviewed;
  int? countPhieuSyncSuccess;

  ProgressModel(
      {this.maDoiTuongDT,
      this.tenDoiTuongDT,
      this.moTaDoiTuongDT,
      this.countPhieuInterviewed,
      this.countPhieuUnInterviewed,
      this.countPhieuSyncSuccess});

  ProgressModel.fromJson(Map json) {
    maDoiTuongDT = json['MaDoiTuongDT'];
    tenDoiTuongDT = json['TenDoiTuongDT'];
    moTaDoiTuongDT = json['MoTaDoiTuongDT'];
    countPhieuInterviewed = json['CountPhieuInterviewed'];
    countPhieuUnInterviewed = json['CountPhieuUnInterviewed'];
    countPhieuSyncSuccess = json['CountPhieuSyncSuccess'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaDoiTuongDT'] = maDoiTuongDT;
    data['TenDoiTuongDT'] = tenDoiTuongDT;
    data['MoTaDoiTuongDT'] = moTaDoiTuongDT;
    data['CountPhieuInterviewed'] = countPhieuInterviewed;
    data['CountPhieuUnInterviewed'] = countPhieuUnInterviewed;
    data['CountPhieuSyncSuccess'] = countPhieuSyncSuccess;
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
