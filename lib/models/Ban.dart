class Ban {
  final String? maBan;
  final String? tenBan;
  final String? maCuocThi;
  final String? moTa;

  Ban({this.maBan, this.tenBan, this.maCuocThi, this.moTa});

  factory Ban.fromJson(Map<String, dynamic> json) {
    return Ban(
      maBan: json['maban'],
      tenBan: json['tenban'],
      maCuocThi: json['macuocthi'],
      moTa: json['mota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maban': maBan,
      'tenban': tenBan,
      'macuocthi': maCuocThi,
      'mota': moTa,
    };
  }
}
