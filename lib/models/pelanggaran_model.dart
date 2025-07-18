class RekapPelanggaranResponse {
  final int status;
  final String message;
  final List<RekapPelanggaranItem> data;

  RekapPelanggaranResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RekapPelanggaranResponse.fromJson(Map<String, dynamic> json) {
    return RekapPelanggaranResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => RekapPelanggaranItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RekapPelanggaranItem {
  final int kategori;
  final int jumlah;
  final String viewKategori;

  RekapPelanggaranItem({
    required this.kategori,
    required this.jumlah,
    required this.viewKategori,
  });

  factory RekapPelanggaranItem.fromJson(Map<String, dynamic> json) {
    return RekapPelanggaranItem(
      kategori: json['kategori'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
      viewKategori: (json['viewKategori'] ?? '').toString(),
    );
  }
}

class DetailPelanggaranResponse {
  final int status;
  final String message;
  final int jumlah;
  final List<DetailPelanggaranItem> data;

  DetailPelanggaranResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory DetailPelanggaranResponse.fromJson(Map<String, dynamic> json) {
    return DetailPelanggaranResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => DetailPelanggaranItem.fromJson(item))
          .toList(),
    );
  }
}

class DetailPelanggaranItem {
  final String nama;
  final String tanggal;
  final String jenisPelanggaran;
  final String kategori;
  final String hukuman;
  final String? bukti;

  DetailPelanggaranItem({
    required this.nama,
    required this.tanggal,
    required this.jenisPelanggaran,
    required this.kategori,
    required this.hukuman,
    this.bukti,
  });

  factory DetailPelanggaranItem.fromJson(Map<String, dynamic> json) {
    return DetailPelanggaranItem(
      nama: json['nama'] ?? '',
      tanggal: json['tanggal'] ?? '',
      jenisPelanggaran: json['jenisPelanggaran'] ?? '',
      kategori: json['kategori'] ?? '',
      hukuman: json['hukuman'] ?? '',
      bukti: json['bukti'],
    );
  }
}
