class DmCommonModel {
  int? ma;
  String? ten;

  DmCommonModel({this.ma, this.ten});

  DmCommonModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    return map;
  }

  static List<DmCommonModel> listFromJson(dynamic json) {
    List<DmCommonModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmCommonModel.fromJson(value));
      }
    }
    return list;
  }
}

class DmCommonSTTModel {
  int? ma;
  String? ten;
  int? stt;

  DmCommonSTTModel({this.ma, this.ten, this.stt});

  DmCommonSTTModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
    stt = json['STT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    map['STT'] = stt;
    return map;
  }

  static List<DmCommonSTTModel> listFromJson(dynamic json) {
    List<DmCommonSTTModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmCommonSTTModel.fromJson(value));
      }
    }
    return list;
  }
}

/**********/
///ĐT quốc tịch
class DmQuocTichModel {
  int? maQuocTich;
  String? tenQuocTich;

  DmQuocTichModel({this.maQuocTich, this.tenQuocTich});

  DmQuocTichModel.fromJson(dynamic json) {
    maQuocTich = json['MaQuocTich'];
    tenQuocTich = json['TenQuocTich'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaQuocTich'] = maQuocTich;
    map['TenQuocTich'] = tenQuocTich;
    return map;
  }

  static List<DmQuocTichModel> listFromJson(dynamic json) {
    List<DmQuocTichModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmQuocTichModel.fromJson(value));
      }
    }
    return list;
  }
}

/**********/
///
class TGDmNangLuongModel {
  String? ma;
  String? ten;
  int? ghiRo;

  TGDmNangLuongModel({this.ma, this.ten, this.ghiRo});

  TGDmNangLuongModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
    ghiRo = json['GhiRo'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    map['GhiRo'] = ghiRo;
    return map;
  }

  static List<TGDmNangLuongModel> listFromJson(dynamic json) {
    List<TGDmNangLuongModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(TGDmNangLuongModel.fromJson(value));
      }
    }
    return list;
  }
}

class TGDmTrinhDoChuyenMonModel {
  int? ma;
  String? ten;
  int? ghiRo;

  TGDmTrinhDoChuyenMonModel({this.ma, this.ten, this.ghiRo});

  TGDmTrinhDoChuyenMonModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
    ghiRo = json['GhiRo'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    map['GhiRo'] = ghiRo;
    return map;
  }

  static List<TGDmTrinhDoChuyenMonModel> listFromJson(dynamic json) {
    List<TGDmTrinhDoChuyenMonModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(TGDmTrinhDoChuyenMonModel.fromJson(value));
      }
    }
    return list;
  }
}

class DmLinhVucModel {
  String? ma;
  String? ten;

  DmLinhVucModel({this.ma, this.ten});

  DmLinhVucModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    return map;
  }

  static List<DmLinhVucModel> listFromJson(dynamic json) {
    List<DmLinhVucModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmLinhVucModel.fromJson(value));
      }
    }
    return list;
  }
}

class SearchTypeModel {
  int? ma;
  String? ten;
  bool? selected;

  SearchTypeModel({this.ma, this.ten, this.selected});

  SearchTypeModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
    selected = json['Selected'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    map['Selected'] = selected;
    return map;
  }

  static List<SearchTypeModel> listFromJson(dynamic json) {
    List<SearchTypeModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(SearchTypeModel.fromJson(value));
      }
    }
    return list;
  }
}
