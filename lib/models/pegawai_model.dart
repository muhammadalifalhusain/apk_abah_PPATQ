class Pegawai {
  final String photo;
  final String nama;
  final String jenisKelamin;

  Pegawai({
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      photo: (json['photo'] ?? '').toString().isEmpty
          ? 'default.png' // fallback jika kosong
          : json['photo'],
      nama: (json['nama'] ?? '').toString().isEmpty
          ? 'Tidak diketahui'
          : json['nama'],
      jenisKelamin: (json['jenisKelamin'] ?? '').toString().isEmpty
          ? 'Tidak diketahui'
          : json['jenisKelamin'],
    );
  }
}

class PegawaiResponse {
  final List<Pegawai> data;
  final String message;
  final int status;

  PegawaiResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory PegawaiResponse.fromJson(Map<String, dynamic> json) {
    var list = (json['data'] as List?) ?? [];
    List<Pegawai> pegawaiList = list.map((e) => Pegawai.fromJson(e)).toList();

    return PegawaiResponse(
      data: pegawaiList,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
