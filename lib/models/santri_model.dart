class Santri {
  final String photo;
  final String nama;
  final String jenisKelamin;
  final String kelas;

  Santri({
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
    required this.kelas,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      photo: (json['photo'] ?? '').toString().trim(),
      nama: (json['nama'] ?? '').toString().trim().isNotEmpty
          ? json['nama']
          : 'Tidak diketahui',
      jenisKelamin: _mapGender(json['jenisKelamin']),
      kelas: (json['kelas'] ?? '').toString().trim().isNotEmpty
          ? json['kelas']
          : '-',
    );
  }

  /// Helper untuk mengonversi 'L' → 'Laki-laki', 'P' → 'Perempuan'
  static String _mapGender(dynamic value) {
    final code = value?.toString().toUpperCase();
    if (code == 'L') return 'Laki-laki';
    if (code == 'P') return 'Perempuan';
    return '-';
  }
}

class SantriResponse {
  final int status;
  final String message;
  final List<Santri> data;

  SantriResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SantriResponse.fromJson(Map<String, dynamic> json) {
    return SantriResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => Santri.fromJson(e))
          .toList(),
    );
  }
}
