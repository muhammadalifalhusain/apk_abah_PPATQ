class KeuanganKelasResponse {
  final int status;
  final String message;
  final int jumlah;
  final DataUangSaku? data;

  KeuanganKelasResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    this.data,
  });

  factory KeuanganKelasResponse.fromJson(Map<String, dynamic> json) {
    return KeuanganKelasResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: json['data'] != null ? DataUangSaku.fromJson(json['data']) : null,
    );
  }
}

class DataUangSaku {
  final DataKelas? dataKelas;
  final List<SantriUang>? surplus;
  final List<SantriUang>? minus;

  DataUangSaku({
    this.dataKelas,
    this.surplus,
    this.minus,
  });

  factory DataUangSaku.fromJson(Map<String, dynamic> json) {
    return DataUangSaku(
      dataKelas: json['dataKelas'] != null
          ? DataKelas.fromJson(json['dataKelas'])
          : null,
      surplus: (json['surplus'] as List?)
              ?.map((e) => SantriUang.fromJson(e))
              .toList() ??
          [],
      minus: (json['minus'] as List?)
              ?.map((e) => SantriUang.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DataKelas {
  final String? namaWaliKelas;
  final String? fotoWaliKelas;
  final String? namaKelas;

  DataKelas({
    this.namaWaliKelas,
    this.fotoWaliKelas,
    this.namaKelas,
  });

  factory DataKelas.fromJson(Map<String, dynamic> json) {
    return DataKelas(
      namaWaliKelas: json['namaWaliKelas']?.toString() ?? '',
      fotoWaliKelas: json['fotoWaliKelas']?.toString() ?? '',
      namaKelas: json['namaKelas']?.toString() ?? '',
    );
  }
}

class SantriUang {
  final String? photo;
  final String? nama;
  final String? jenisKelamin;
  final String? uangMasuk;
  final String? uangKeluar;
  final int? saldo;
  final String? murroby;
  final String? totalUangMasuk;
  final String? totalUangKeluar;
  final String? saldoFormatted;

  SantriUang({
    this.photo,
    this.nama,
    this.jenisKelamin,
    this.uangMasuk,
    this.uangKeluar,
    this.saldo,
    this.murroby,
    this.totalUangMasuk,
    this.totalUangKeluar,
    this.saldoFormatted,
  });

  factory SantriUang.fromJson(Map<String, dynamic> json) {
    return SantriUang(
      photo: json['photo']?.toString(),
      nama: json['nama']?.toString(),
      jenisKelamin: json['jenisKelamin']?.toString(),
      uangMasuk: json['uangMasuk']?.toString(),
      uangKeluar: json['uangKeluar']?.toString(),
      saldo: json['saldo'] != null ? int.tryParse(json['saldo'].toString()) : 0,
      murroby: json['murroby']?.toString(),
      totalUangMasuk: json['totalUangMasuk']?.toString(),
      totalUangKeluar: json['totalUangKeluar']?.toString(),
      saldoFormatted: json['saldoFormatted']?.toString(),
    );
  }
  String get jenisKelaminFormatted {
    if (jenisKelamin == null || jenisKelamin!.isEmpty) return '-';
    switch (jenisKelamin) {
      case 'L':
        return 'Laki-laki';
      case 'P':
        return 'Perempuan';
      default:
        return jenisKelamin!;
    }
  }

  /// Format nama santri: jika kosong/null, tampilkan "-"
  String get namaFormatted => nama?.isNotEmpty == true ? nama! : '-';

  /// Format murroby: jika kosong/null, tampilkan "-"
  String get murrobyFormatted => murroby?.isNotEmpty == true ? murroby! : '-';
  bool get isMinus => (saldo ?? 0) < 0;
}


//Model untuk syahriah
class KeuanganSyahriahResponse {
  final int status;
  final String message;
  final KeuanganSyahriahData data;

  KeuanganSyahriahResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KeuanganSyahriahResponse.fromJson(Map<String, dynamic> json) {
    return KeuanganSyahriahResponse(
      status: json['status'],
      message: json['message'],
      data: KeuanganSyahriahData.fromJson(json['data']),
    );
  }
}

class KeuanganSyahriahData {
  final String bulan;
  final String totalTagihanSyahriah;
  final String totalPembayaranValidBulanIni;
  final String totalPembayaranUnvalidBulanIni;
  final int totalTunggakan;
  final List<KelasKeuangan> dataKelas;

  KeuanganSyahriahData({
    required this.bulan,
    required this.totalTagihanSyahriah,
    required this.totalPembayaranValidBulanIni,
    required this.totalPembayaranUnvalidBulanIni,
    required this.totalTunggakan,
    required this.dataKelas,
  });

  factory KeuanganSyahriahData.fromJson(Map<String, dynamic> json) {
    return KeuanganSyahriahData(
      bulan: json['bulan'],
      totalTagihanSyahriah: json['totalTagihanSyahriah'],
      totalPembayaranValidBulanIni: json['totalPembayaranValidBulanIni'],
      totalPembayaranUnvalidBulanIni: json['totalPembayaranUnvalidBulanIni'],
      totalTunggakan: json['totalTunggakan'],
      dataKelas: List<KelasKeuangan>.from(
        json['dataKelas'].map((x) => KelasKeuangan.fromJson(x)),
      ),
    );
  }
}

class KelasKeuangan {
  final String kode;
  final String namaKelas;

  KelasKeuangan({
    required this.kode,
    required this.namaKelas,
  });

  factory KelasKeuangan.fromJson(Map<String, dynamic> json) {
    return KelasKeuangan(
      kode: json['kode'],
      namaKelas: json['namaKelas'],
    );
  }
}

//respon detail syahriah
class LaporanSyahriahResponse {
  final int status;
  final String message;
  final int jumlah;
  final LaporanSyahriahData data;

  LaporanSyahriahResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory LaporanSyahriahResponse.fromJson(Map<String, dynamic> json) {
    return LaporanSyahriahResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: LaporanSyahriahData.fromJson(json['data'] ?? {}),
    );
  }
}

class LaporanSyahriahData {
  final DataKelas? dataKelas;
  final Map<String, List<Santri>> santri;

  LaporanSyahriahData({
    required this.dataKelas,
    required this.santri,
  });

  factory LaporanSyahriahData.fromJson(Map<String, dynamic> json) {
    final rawSantri = json['santri'] ?? {};

    // Pastikan robust: buat map dari key dynamic ke list Santri
    final Map<String, List<Santri>> parsedSantri = {};
    for (var key in rawSantri.keys) {
      final list = rawSantri[key] as List?;
      parsedSantri[key] = list != null
          ? list.map((e) => Santri.fromJson(e ?? {})).toList()
          : [];
    }

    return LaporanSyahriahData(
      dataKelas: json['dataKelas'] != null
          ? DataKelas.fromJson(json['dataKelas'])
          : null,
      santri: parsedSantri,
    );
  }
}

class DataKelasSyahriah{
  final String namaWaliKelas;
  final String fotoWaliKelas;
  final String namaKelas;

  DataKelasSyahriah({
    required this.namaWaliKelas,
    required this.fotoWaliKelas,
    required this.namaKelas,
  });

  factory DataKelasSyahriah.fromJson(Map<String, dynamic> json) {
    return DataKelasSyahriah(
      namaWaliKelas: json['namaWaliKelas'] ?? '',
      fotoWaliKelas: json['fotoWaliKelas'] ?? '',
      namaKelas: json['namaKelas'] ?? '',
    );
  }
}

class Santri {
  final int noInduk;
  final String? photo;
  final String nama;
  final String tanggalBayar;
  final String validasi;
  final String status;

  Santri({
    required this.noInduk,
    required this.photo,
    required this.nama,
    required this.tanggalBayar,
    required this.validasi,
    required this.status,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['noInduk'] ?? 0,
      photo: json['photo']?.toString(),
      nama: json['nama'] ?? '',
      tanggalBayar: json['tanggalBayar'] ?? '',
      validasi: json['validasi'] ?? '',
      status: json['status'] ?? '',
    );
  }

  bool get isValid => validasi.toLowerCase() == 'valid';
  bool get isBelumBayar => status.toLowerCase() == 'belum bayar';
}
