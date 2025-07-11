class Kamar {
  final int id;
  final String namaKamar;
  final String murroby;

  Kamar({
    required this.id,
    required this.namaKamar,
    required this.murroby,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      final str = (value ?? '').toString().trim();
      return str.isNotEmpty ? str : '-';
    }

    return Kamar(
      id: json['id'] ?? 0,
      namaKamar: parseString(json['namaKamar']),
      murroby: parseString(json['murroby']),
    );
  }
}

class KamarResponse {
  final int status;
  final String message;
  final int jumlah;
  final List<Kamar> data;

  KamarResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory KamarResponse.fromJson(Map<String, dynamic> json) {
    return KamarResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: (json['data'] as List)
          .map((item) => Kamar.fromJson(item))
          .toList(),
    );
  }
}

