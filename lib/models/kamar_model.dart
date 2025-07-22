class Kamar {
  final int id;
  final String namaKamar;
  final String murroby;
  final String? fotoMurroby;

  Kamar({
    required this.id,
    required this.namaKamar,
    required this.murroby,
    this.fotoMurroby,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    String? parseNullableString(dynamic value) {
      final str = (value ?? '').toString().trim();
      return str.isEmpty ? null : str;
    }

    return Kamar(
      id: json['id'] ?? 0,
      namaKamar: (json['namaKamar'] ?? '').toString(),
      murroby: (json['murroby'] ?? '').toString(),
      fotoMurroby: parseNullableString(json['fotoMurroby']),
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
  final int noInduk;
  final String photo;
  final String nama;
  final String jenisKelamin;
  final String asalKota;
  final String capaian;

  Santri({
    required this.noInduk,
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
    required this.asalKota,
    required this.capaian,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['noInduk'] ?? '',
      photo: json['photo'] ?? '',
      nama: json['nama'] ?? '-',
      jenisKelamin: json['jenisKelamin'] ?? '-',
      asalKota: json['asalKota'] ?? '-',
      capaian: json['capaian'] ?? '-',
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

class SakuResponse {
  final int status;
  final String message;
  final SakuData data;

  SakuResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SakuResponse.fromJson(Map<String, dynamic> json) {
    return SakuResponse(
      status: json['status'],
      message: json['message'],
      data: SakuData.fromJson(json['data']),
    );
  }
}

class SakuData {
  final int saldo;
  final String waktu;
  final List<UangMasuk> uangMasuk;
  final List<UangKeluar> uangKeluar;

  SakuData({
    required this.saldo,
    required this.waktu,
    required this.uangMasuk,
    required this.uangKeluar,
  });

  factory SakuData.fromJson(Map<String, dynamic> json) {
    return SakuData(
      saldo: json['saldo'],
      waktu: json['waktu'],
      uangMasuk: (json['uangMasuk'] as List)
          .map((e) => UangMasuk.fromJson(e))
          .toList(),
      uangKeluar: (json['uangKeluar'] as List)
          .map((e) => UangKeluar.fromJson(e))
          .toList(),
    );
  }
}

class UangMasuk {
  final String uangAsal;
  final int jumlahMasuk;
  final String tanggalTransaksi;

  UangMasuk({
    required this.uangAsal,
    required this.jumlahMasuk,
    required this.tanggalTransaksi,
  });

  factory UangMasuk.fromJson(Map<String, dynamic> json) {
    return UangMasuk(
      uangAsal: json['uangAsal'],
      jumlahMasuk: json['jumlahMasuk'],
      tanggalTransaksi: json['tanggalTransaksi'],
    );
  }
}

class UangKeluar {
  final int jumlahKeluar;
  final String catatan;
  final String tanggalTransaksi;
  final String namaMurroby;

  UangKeluar({
    required this.jumlahKeluar,
    required this.catatan,
    required this.tanggalTransaksi,
    required this.namaMurroby,
  });

  factory UangKeluar.fromJson(Map<String, dynamic> json) {
    return UangKeluar(
      jumlahKeluar: json['jumlahKeluar'],
      catatan: json['catatan'],
      tanggalTransaksi: json['tanggalTransaksi'],
      namaMurroby: json['namaMurroby'],
    );
  }
}



