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

class QuestionGroupByMaPhieu {
  int? id;
  int? maPhieu;
  String? tenPhieu;
  bool? enable;
  List<QuestionGroupByManHinh>? questionGroupByManHinh;

  QuestionGroupByMaPhieu(
      {this.id,
      this.maPhieu,
      this.tenPhieu,
      this.enable,
      this.questionGroupByManHinh});

  QuestionGroupByMaPhieu.fromJson(dynamic json) {
    id = json['Id'];
    maPhieu = json['MaPhieu'];
    tenPhieu = json['TenPhieu'];
    enable = json['Enable'];
    questionGroupByManHinh = json['QuestionGroupByManHinh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['MaPhieu'] = maPhieu;
    data['TenPhieu'] = tenPhieu;
    data['Enable'] = enable;
    data['QuestionGroupByManHinh'] = questionGroupByManHinh;
    return data;
  }

  static List<QuestionGroupByMaPhieu> listFromJson(dynamic json) {
    List<QuestionGroupByMaPhieu> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(QuestionGroupByMaPhieu.fromJson(item));
      }
    }
    return list;
  }
}

class QuestionGroupByManHinh {
  int? id;
  int? maPhieu;
  int? manHinh;
  String? tenNhomCauHoi;
  String? fromQuestion;
  String? toQuestion;
  String? routeName;
  bool? isSelected;
  bool? enable;

  QuestionGroupByManHinh(
      {this.id,
      this.maPhieu,
      this.manHinh,
      this.tenNhomCauHoi,
      this.fromQuestion,
      this.toQuestion,
      this.routeName,
      this.isSelected,
      this.enable});

  QuestionGroupByManHinh.fromJson(dynamic json) {
    id = json['Id'];
    maPhieu = json['MaPhieu'];
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
    data['MaPhieu'] = maPhieu;
    data['ManHinh'] = manHinh;
    data['TenNhomCauHoi'] = tenNhomCauHoi;
    data['FromQuestion'] = fromQuestion;
    data['ToQuestion'] = toQuestion;
    data['RouteName'] = routeName;
    data['IsSelected'] = isSelected;
    data['Enable'] = enable;
    return data;
  }

  static List<QuestionGroupByManHinh> listFromJson(dynamic json) {
    List<QuestionGroupByManHinh> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(QuestionGroupByManHinh.fromJson(item));
      }
    }
    return list;
  }
}
