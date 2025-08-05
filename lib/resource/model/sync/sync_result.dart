class SyncResult {
  bool? isSuccess;
  int? countSuccess;
  int? countFailed;
  List<SyncResultItem>? syncResultItems;
  SyncResult(
      {this.isSuccess,
      this.countFailed,
      this.countSuccess,
      this.syncResultItems});

  SyncResult.fromJson(dynamic json) {
    isSuccess = json['IsSuccess'];
    countSuccess = json['CountSuccess'];
    countFailed = json['CountFailed'];
    syncResultItems = json['SyncResultItems'] != null
        ? SyncResultItem.listFromJson(json['SyncResultItems'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CountSuccess'] = countSuccess;
    data['CountFailed'] = countFailed;
    data['IsSuccess'] = isSuccess;
    data['SyncResultItems'] = syncResultItems;
    return data;
  }

  static List<SyncResult> listFromJson(dynamic json) {
    List<SyncResult> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(SyncResult.fromJson(item));
      }
    }
    return list;
  }
}

class SyncResultItem {
  int? maDoiTuongDT;
  String? tenDoiTuongDT;
  List<SyncResultDetailItem>? syncResultDetailItems;

  SyncResultItem.fromJson(dynamic json) {
    maDoiTuongDT = json['MaDoiTuongDT'];
    tenDoiTuongDT = json['TenDoiTuongDT'];

    syncResultDetailItems = json['SyncResultDetails'] != null
        ? SyncResultDetailItem.listFromJson(json['SyncResultDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MaDoiTuongDT'] = maDoiTuongDT;
    data['TenDoiTuongDT'] = tenDoiTuongDT;

    data['SyncResultDetails'] = syncResultDetailItems;
    return data;
  }

  static List<SyncResultItem> listFromJson(dynamic json) {
    List<SyncResultItem> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(SyncResultItem.fromJson(item));
      }
    }
    return list;
  }
}

class SyncResultDetailItem {
  String? id;
  String? ten;
  String? maXa;
  String? maDiaBan;
  int? isSuccess;
  int? isUpdate;
  String? errorMessage;

  SyncResultDetailItem(
      {this.id,
      this.ten,
      this.maXa,
      this.maDiaBan,
      this.isSuccess,
      this.isUpdate,
      this.errorMessage});

  SyncResultDetailItem.fromJson(dynamic json) {
    id = json['Id'];
    ten = json['Ten'];
    maXa = json['MaXa'];
    maDiaBan = json['MaDiaBan'];
    isSuccess = json['IsSuccess'] == true ? 1 : 0;
    isUpdate = json['IsUpdate'] == true ? 1 : 0;
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Ten'] = ten;
    data['MaXa'] = maXa;
    data['MaDiaBan'] = maDiaBan;
    data['IsSuccess'] = isSuccess;
    data['IsUpdate'] = isUpdate;
    data['ErrorMessage'] = errorMessage;
    return data;
  }

  static List<SyncResultDetailItem> listFromJson(dynamic json) {
    List<SyncResultDetailItem> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(SyncResultDetailItem.fromJson(item));
      }
    }
    return list;
  }

  @override
  String toString() {
    return (maDiaBan == null || maDiaBan == '')
        ? "$maXa - $ten"
        : "$maXa - $maDiaBan - $ten";
  }
}
