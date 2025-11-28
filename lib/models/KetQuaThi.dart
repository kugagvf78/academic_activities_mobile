class KetQuaThi {
  final String? maKetQua;
  final String? maBaiThi;
  final double? diem;
  final int? xepHang;
  final String? giaiThuong;
  final String? nhanXet;
  final String? ngayChamDiem;
  final String? nguoiChamDiem;

  KetQuaThi({
    this.maKetQua,
    this.maBaiThi,
    this.diem,
    this.xepHang,
    this.giaiThuong,
    this.nhanXet,
    this.ngayChamDiem,
    this.nguoiChamDiem,
  });

  factory KetQuaThi.fromJson(Map<String, dynamic> json) {
    return KetQuaThi(
      maKetQua: json['maketqua'],
      maBaiThi: json['mabaithi'],
      diem: (json['diem'] as num?)?.toDouble(),
      xepHang: json['xephang'],
      giaiThuong: json['giaithuong'],
      nhanXet: json['nhanxet'],
      ngayChamDiem: json['ngaychamdiem'],
      nguoiChamDiem: json['nguoichamdiem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maketqua': maKetQua,
      'mabaithi': maBaiThi,
      'diem': diem,
      'xephang': xepHang,
      'giaithuong': giaiThuong,
      'nhanxet': nhanXet,
      'ngaychamdiem': ngayChamDiem,
      'nguoichamdiem': nguoiChamDiem,
    };
  }
}
