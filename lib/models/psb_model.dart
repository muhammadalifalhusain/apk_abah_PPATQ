class PsbResponse {
  final int status;
  final String message;
  final List<PsbData> data;

  PsbResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PsbResponse.fromJson(Map<String, dynamic> json) {
    return PsbResponse(
      status: json['status'] is int ? json['status'] : 0,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List?)?.map((e) {
            if (e is Map<String, dynamic>) {
              return PsbData.fromJson(e);
            }
            return PsbData.fallback(); 
          }).toList() ??
          [],
    );
  }
}

class PsbData {
  final String nama;
  final String jenisKelamin;
  final String asal;

  PsbData({
    required this.nama,
    required this.jenisKelamin,
    required this.asal,
  });

  factory PsbData.fromJson(Map<String, dynamic> json) {
    return PsbData(
      nama: _safeString(json['nama'], fallback: 'Tidak diketahui'),
      jenisKelamin: _mapGender(json['jenisKelamin']),
      asal: _safeString(json['asal'], fallback: 'Asal tidak tersedia'),
    );
  }

  factory PsbData.fallback() {
    return PsbData(
      nama: 'Tidak diketahui',
      jenisKelamin: '-',
      asal: 'Asal tidak tersedia',
    );
  }

  static String _safeString(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final stringVal = value.toString().trim();
    return stringVal.isEmpty ? fallback : stringVal;
  }

  static String _mapGender(dynamic value) {
    final code = value?.toString().toUpperCase();
    if (code == 'L') return 'Laki-laki';
    if (code == 'P') return 'Perempuan';
    return '-';
  }
}
