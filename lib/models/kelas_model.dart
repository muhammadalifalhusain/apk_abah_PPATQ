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

class KelasDetailResponse {
  final int status;
  final String message;
  final int jumlah;
  final KelasDetail data;

  KelasDetailResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory KelasDetailResponse.fromJson(Map<String, dynamic> json) {
    return KelasDetailResponse(
      status: json['status'],
      message: json['message'],
      jumlah: json['jumlah'] ?? 0,
      data: KelasDetail.fromJson(json['data']),
    );
  }
}

class KelasDetail {
  final DataKamar? dataKamar;
  final List<Santri> santri;

  KelasDetail({
    required this.dataKamar,
    required this.santri,
  });

  factory KelasDetail.fromJson(Map<String, dynamic> json) {
    return KelasDetail(
      dataKamar: json['dataKamar'] != null
          ? DataKamar.fromJson(json['dataKamar'])
          : null,
      santri: (json['santri'] as List<dynamic>)
          .map((e) => Santri.fromJson(e))
          .toList(),
    );
  }
}

class DataKamar {
  final String namaMurroby;
  final String fotoMurroby;
  final String namaKamar;

  DataKamar({
    required this.namaMurroby,
    required this.fotoMurroby,
    required this.namaKamar,
  });

  factory DataKamar.fromJson(Map<String, dynamic> json) {
    return DataKamar(
      namaMurroby: json['namaMurroby'] ?? '',
      fotoMurroby: json['fotoMurroby'] ?? '',
      namaKamar: json['namaKamar'] ?? '',
    );
  }
}

class Santri {
  final String? photo;
  final String nama;
  final String jenisKelamin;

  Santri({
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      photo: json['photo'],
      nama: json['nama'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
    );
  }
}
