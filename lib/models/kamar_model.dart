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

class Santri {
  final String nama;
  final String jenisKelamin;
  final String photo;

  Santri({
    required this.nama,
    required this.jenisKelamin,
    required this.photo,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      nama: json['nama'] ?? '-',
      jenisKelamin: json['jenisKelamin'] ?? '-',
      photo: json['photo'] ?? '',
    );
  }
}

class DataKamarDetail {
  final String namaMurroby;
  final String fotoMurroby;
  final String namaKamar;

  DataKamarDetail({
    required this.namaMurroby,
    required this.fotoMurroby,
    required this.namaKamar,
  });

  factory DataKamarDetail.fromJson(Map<String, dynamic> json) {
    return DataKamarDetail(
      namaMurroby: json['namaMurroby'] ?? '-',
      fotoMurroby: json['fotoMurroby'] ?? '',
      namaKamar: json['namaKamar'] ?? '-',
    );
  }
}

class KamarDetailData {
  final DataKamarDetail? dataKamar;
  final List<Santri> santri;

  KamarDetailData({
    required this.dataKamar,
    required this.santri,
  });

  factory KamarDetailData.fromJson(Map<String, dynamic> json) {
    return KamarDetailData(
      dataKamar: json['dataKamar'] != null
          ? DataKamarDetail.fromJson(json['dataKamar'])
          : null,
      santri: (json['santri'] as List)
          .map((e) => Santri.fromJson(e))
          .toList(),
    );
  }
}

class KamarDetailResponse {
  final int status;
  final String message;
  final int jumlah;
  final KamarDetailData data;

  KamarDetailResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory KamarDetailResponse.fromJson(Map<String, dynamic> json) {
    return KamarDetailResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: KamarDetailData.fromJson(json['data']),
    );
  }
}


