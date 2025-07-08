class PegawaiData {
  final String photo;
  final String nama;
  final String jenisKelamin;

  PegawaiData({
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
  });

  factory PegawaiData.fromJson(Map<String, dynamic> json) {
    return PegawaiData(
      photo: (json['photo'] ?? '').toString().isNotEmpty
          ? json['photo']
          : 'default.png',
      nama: (json['nama'] ?? '').toString().isNotEmpty
          ? json['nama']
          : 'Tidak diketahui',
      jenisKelamin: (json['jenisKelamin'] ?? '').toString().isNotEmpty
          ? json['jenisKelamin']
          : 'Tidak diketahui',
    );
  }
}

class PegawaiResponse {
  final List<PegawaiData> data;

  PegawaiResponse({required this.data});

  factory PegawaiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<PegawaiData> pegawaiList =
        list.map((e) => PegawaiData.fromJson(e)).toList();
    return PegawaiResponse(data: pegawaiList);
  }
}
