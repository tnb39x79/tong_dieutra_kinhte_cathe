class QuestionGroup {
  int? id;
  int? manHinh;
  String? tenNhomCauHoi;
  String? fromQuestion;
  String? toQuestion;
  String? routeName;
  bool? isSelected;
  bool? enable;

  QuestionGroup(
      {this.id,
      this.manHinh,
      this.tenNhomCauHoi,
      this.fromQuestion,
      this.toQuestion,
      this.routeName,
      this.isSelected,
      this.enable});

  QuestionGroup.fromJson(dynamic json) {
    id = json['Id'];
    manHinh = json['ManHinh'];
    tenNhomCauHoi = json['TenNhomCauHoi'];
    fromQuestion = json['FromQuestion'];
    toQuestion = json['ToQuestion'];
    routeName = json['RouteName'];
    isSelected = json['IsSelected'];
    enable = json['Enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ManHinh'] = manHinh;
    data['TenNhomCauHoi'] = tenNhomCauHoi;
    data['FromQuestion'] = fromQuestion;
    data['ToQuestion'] = toQuestion;
    data['RouteName'] = routeName;
    data['IsSelected'] = isSelected;
    data['Enable'] = enable;
    return data;
  }

  static List<QuestionGroup> listFromJson(dynamic json) {
    List<QuestionGroup> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(QuestionGroup.fromJson(item));
      }
    }
    return list;
  }
}
