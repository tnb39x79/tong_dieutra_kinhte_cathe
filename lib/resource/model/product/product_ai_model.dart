class ProductAiModel {
  String? name;
  String? code;
  double? score;
  double? frequency;
  ProductAiModel({
    this.name,
    this.code,
    this.score,
    this.frequency,
  });

  ProductAiModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    score = json['score'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['score'] = score;
    data['frequency'] = frequency;
    return data;
  }
  static List<ProductAiModel> listFromJson(dynamic json){
    List<ProductAiModel> list = [];
    list = List<ProductAiModel>.from(json.map((model)=> ProductAiModel.fromJson(model)));
    return list;
  }
      
}
