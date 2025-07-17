class PelanggaranResponse {
  final int status;
  final String message;
  final int jumlah;
  final List<Pelanggaran> data;

  PelanggaranResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory PelanggaranResponse.fromJson(Map<String, dynamic> json) {
    return PelanggaranResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: (json['data'] as List?)
              ?.map((item) => Pelanggaran.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Pelanggaran {
  final String nama;
  final String tanggal;
  final String jenisPelanggaran;
  final String kategori;
  final String hukuman;
  final String bukti;

  Pelanggaran({
    required this.nama,
    required this.tanggal,
    required this.jenisPelanggaran,
    required this.kategori,
    required this.hukuman,
    required this.bukti,
  });

  factory Pelanggaran.fromJson(Map<String, dynamic> json) {
    return Pelanggaran(
      nama: _parseString(json['nama']),
      tanggal: _parseString(json['tanggal']),
      jenisPelanggaran: _parseString(json['jenisPelanggaran']),
      kategori: _parseString(json['kategori']),
      hukuman: _parseString(json['hukuman']),
      bukti: _parseString(json['bukti']),
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return '-';
    final str = value.toString().trim();
    return str.isEmpty ? '-' : str;
  }
}
