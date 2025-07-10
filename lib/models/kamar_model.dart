class Kamar {
  final String namaKelas;
  final String murroby;

  Kamar({
    required this.namaKelas,
    required this.murroby,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      final str = (value ?? '').toString().trim();
      return str.isNotEmpty ? str : '-';
    }

    return Kamar(
      namaKelas: parseString(json['namaKelas']),
      murroby: parseString(json['murroby']),
    );
  }
}

class KamarResponse {
  final int status;
  final String message;
  final List<Kamar> data;

  KamarResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KamarResponse.fromJson(Map<String, dynamic> json) {
    return KamarResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => Kamar.fromJson(item))
          .toList(),
    );
  }
}
