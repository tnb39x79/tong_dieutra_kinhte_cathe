///Trạng thái điều tra
class InvestigateObjectModel {
  int? maDoiTuongDT;
  String? tenDoiTuongDT;
  String? moTaDoiTuongDT; 

  InvestigateObjectModel(
      {this.maDoiTuongDT,
      this.tenDoiTuongDT,
      this.moTaDoiTuongDT });

  InvestigateObjectModel.fromJson(dynamic json) {
    maDoiTuongDT = json['MaDoiTuongDT'];
    tenDoiTuongDT = json['TenPhieuCaPi'];
    moTaDoiTuongDT = json['MoTaDoiTuongDT']; 
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaDoiTuongDT'] = maDoiTuongDT;
    map['TenPhieuCaPi'] = tenDoiTuongDT;
    map['MoTaDoiTuongDTs'] = moTaDoiTuongDT; 
    return map;
  }

  static List<InvestigateObjectModel> listFromJson(dynamic json) {
    List<InvestigateObjectModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(InvestigateObjectModel.fromJson(value));
      }
    }
    return list;
  }
}
