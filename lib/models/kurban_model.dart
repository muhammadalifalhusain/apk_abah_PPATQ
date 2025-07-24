class QurbanSummaryResponse {
  final int status;
  final String message;
  final QurbanSummaryData data;

  QurbanSummaryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QurbanSummaryResponse.fromJson(Map<String, dynamic> json) {
    return QurbanSummaryResponse(
      status: json['status'],
      message: json['message'],
      data: QurbanSummaryData.fromJson(json['data']),
    );
  }
}

class QurbanSummaryData {
  final int tahunHijriah;
  final List<QurbanSummaryItem> data;

  QurbanSummaryData({
    required this.tahunHijriah,
    required this.data,
  });

  factory QurbanSummaryData.fromJson(Map<String, dynamic> json) {
    return QurbanSummaryData(
      tahunHijriah: json['tahunHijriah'],
      data: (json['data'] as List)
          .map((item) => QurbanSummaryItem.fromJson(item))
          .toList(),
    );
  }
}

class QurbanSummaryItem {
  final int jenis;
  final String viewJenis;
  final int total;

  QurbanSummaryItem({
    required this.jenis,
    required this.viewJenis,
    required this.total,
  });

  factory QurbanSummaryItem.fromJson(Map<String, dynamic> json) {
    return QurbanSummaryItem(
      jenis: json['jenis'],
      viewJenis: json['viewJenis'],
      total: json['total'],
    );
  }
}

class QurbanDetailResponse {
  final int status;
  final String message;
  final QurbanDetailData data;

  QurbanDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QurbanDetailResponse.fromJson(Map<String, dynamic> json) {
    return QurbanDetailResponse(
      status: json['status'],
      message: json['message'],
      data: QurbanDetailData.fromJson(json['data']),
    );
  }
}

class QurbanDetailData {
  final int tahunHijriah;
  final String jenis;
  final List<QurbanDetailItem> data;

  QurbanDetailData({
    required this.tahunHijriah,
    required this.jenis,
    required this.data,
  });

  factory QurbanDetailData.fromJson(Map<String, dynamic> json) {
    return QurbanDetailData(
      tahunHijriah: json['tahunHijriah'],
      jenis: json['jenis'],
      data: (json['data'] as List)
          .map((item) => QurbanDetailItem.fromJson(item))
          .toList(),
    );
  }
}

class QurbanDetailItem {
  final String nama;
  final String? photo;
  final String atasNama;
  final String? foto;
  final int jumlah;

  QurbanDetailItem({
    required this.nama,
    this.photo,
    required this.atasNama,
    this.foto,
    required this.jumlah,
  });

  factory QurbanDetailItem.fromJson(Map<String, dynamic> json) {
    return QurbanDetailItem(
      nama: json['nama'],
      photo: json['photo'],
      atasNama: json['atasNama'],
      foto: json['foto'],
      jumlah: json['jumlah'],
    );
  }
}

class RiwayatKurbanResponse {
  final int status;
  final String message;
  final List<RiwayatKurban> data;

  RiwayatKurbanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RiwayatKurbanResponse.fromJson(Map<String, dynamic> json) {
    return RiwayatKurbanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '-',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => RiwayatKurban.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RiwayatKurban {
  final String nama;
  final String photo;
  final String atasNama;
  final String foto;
  final String jenis;
  final int jumlah;
  final int tahunHijriah;

  RiwayatKurban({
    required this.nama,
    required this.photo,
    required this.atasNama,
    required this.foto,
    required this.jenis,
    required this.jumlah,
    required this.tahunHijriah,
  });

  factory RiwayatKurban.fromJson(Map<String, dynamic> json) {
    return RiwayatKurban(
      nama: (json['nama'] ?? '-').toString(),
      photo: (json['photo'] ?? '-').toString(),
      atasNama: (json['atasNama'] ?? '-').toString(),
      foto: (json['foto'] ?? '-').toString(),
      jenis: (json['jenis'] ?? '-').toString(),
      jumlah: json['jumlah'] ?? 0,
      tahunHijriah: json['tahunHijriah'] ?? 0,
    );
  }
}
