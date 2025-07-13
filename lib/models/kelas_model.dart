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
  final List<Kelas> data;

  KelasResponse({required this.data});

  factory KelasResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];
    final dataList = list.map((e) => Kelas.fromJson(e)).toList();
    return KelasResponse(data: dataList);
  }
}
