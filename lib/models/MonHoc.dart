class MonHoc {
  final String? maMonHoc;
  final String? tenMonHoc;
  final int? soTinChi;
  final String? maBoMon;
  final String? moTa;

  MonHoc({
    this.maMonHoc,
    this.tenMonHoc,
    this.soTinChi,
    this.maBoMon,
    this.moTa,
  });

  factory MonHoc.fromJson(Map<String, dynamic> json) {
    return MonHoc(
      maMonHoc: json['mamonhoc'],
      tenMonHoc: json['tenmonhoc'],
      soTinChi: json['sotinchi'],
      maBoMon: json['mabomon'],
      moTa: json['mota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mamonhoc': maMonHoc,
      'tenmonhoc': tenMonHoc,
      'sotinchi': soTinChi,
      'mabomon': maBoMon,
      'mota': moTa,
    };
  }
}
  