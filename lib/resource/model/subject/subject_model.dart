class SubjectModel{


  ///Danh sách xã/phường thị trấn
  dynamic danhSachDiaBanCSSXKD;
  

  SubjectModel.fromJson(dynamic json){
    
    danhSachDiaBanCSSXKD = json['DanhSachDiaBanCoSoSXKD'];
   
  }

  static List<SubjectModel> listFromJson(dynamic json){
    List<SubjectModel> list = [];
    list = List<SubjectModel>.from(json.map((model)=> SubjectModel.fromJson(model)));
    return list;
  }
}
