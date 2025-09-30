class LinhVuc {
  String? maLV;
  String? tenLinhVuc;
  String? tuKhoa;
  String? createdAt;
  String? updatedAt;

  LinhVuc({
    this.maLV,
    this.tenLinhVuc,
    this.tuKhoa,
    this.createdAt,
    this.updatedAt,
  });

  LinhVuc.fromJson(Map<String, dynamic> json) {
    maLV = json['MaLV'];
    tenLinhVuc = json['TenLinhVuc'];
    tuKhoa = json['TuKhoa'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MaLV'] = maLV;
    data['TenLinhVuc'] = tenLinhVuc;
    data['TuKhoa'] = tuKhoa;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }

  LinhVuc copyWith({
    String? maLV,
    String? tenLinhVuc,
    String? tuKhoa,
    String? createdAt,
    String? updatedAt,
  }) {
    return LinhVuc(
      maLV: maLV ?? this.maLV,
      tenLinhVuc: tenLinhVuc ?? this.tenLinhVuc,
      tuKhoa: tuKhoa ?? this.tuKhoa,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LinhVuc{maLV: $maLV, tenLinhVuc: $tenLinhVuc, tuKhoa: $tuKhoa}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinhVuc &&
          runtimeType == other.runtimeType &&
          maLV == other.maLV;

  @override
  int get hashCode => maLV.hashCode;
}
