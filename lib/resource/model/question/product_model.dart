

class ProductModel {  
  String? iDCoSo;
  int? sTTSanPham;
  String? maNganh;
  String? tenNganh;
  String? maIO;
  String? tenIO;

  ProductModel({
    this.iDCoSo,
    this.sTTSanPham,
    this.maNganh,
    this.tenNganh,
    this.tenIO
  });

  ProductModel.fromJson(dynamic json) {
   
    iDCoSo = json['IDCoSo'];
    sTTSanPham = json['STT_SanPham'];
    maNganh = json['MaNganh'];
    tenNganh = json['TenNganh'];
    maIO = json['maIO'];
    tenIO = json['TenIO'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['IDCoSo'] = iDCoSo;
    data['STT_SanPham'] = sTTSanPham;
    data['MaNganh'] = maNganh;
    data['TenNganh'] = tenNganh;
    data['MaIO'] = maIO;
    data['TenIO'] = tenIO; 
    return data;
  }

  static List<ProductModel>? listFromJson(dynamic json) {
    List<ProductModel> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(ProductModel.fromJson(item));
      }
    }
    return list;
  }
}
