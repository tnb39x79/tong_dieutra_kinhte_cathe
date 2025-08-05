 

class StartTimeModel {
  String? idHo;
  int? idPhieu;
  String? startTime; 

  StartTimeModel({
    this.idHo,
    this.idPhieu,
    this.startTime, 
  });

  StartTimeModel.fromJson(Map json) {
    idHo = json['IdHo'];
    idPhieu = json['IdPhieu'];
    startTime = json['StartTime']; 
  }

  dynamic toJson() {
    var map = <String, dynamic>{};
    map['IdHo'] = idHo;
    map['IdPhieu'] = idPhieu;
    map['StartTime'] = startTime; 

    return map;
  }
}
