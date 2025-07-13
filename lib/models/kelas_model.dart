class Kelas {
  final String kode;
  final String namaKelas;
  final String guru;

  Kelas({
    required this.kode,
    required this.namaKelas,
    required this.guru,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      kode: json['kode'] ?? '',
      namaKelas: json['namaKelas'] ?? '',
      guru: json['guru'] ?? '',
    );
  }
}

class KelasResponse {
  final int status;
  final String message;
  final List<Kelas> data;

  KelasResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KelasResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Kelas> kelasList = list.map((e) => Kelas.fromJson(e)).toList();

    return KelasResponse(
      status: json['status'],
      message: json['message'],
      data: kelasList,
    );
  }
}
