class BoMon {
  final String? mabomon;
  final String? tenbomon;
  final String? matruongbomon;
  final String? mota;

  BoMon({
    this.mabomon,
    this.tenbomon,
    this.matruongbomon,
    this.mota,
  });

  factory BoMon.fromJson(Map<String, dynamic> json) {
    return BoMon(
      mabomon: json['mabomon'],
      tenbomon: json['tenbomon'],
      matruongbomon: json['matruongbomon'],
      mota: json['mota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mabomon': mabomon,
      'tenbomon': tenbomon,
      'matruongbomon': matruongbomon,
      'mota': mota,
    };
  }
}
