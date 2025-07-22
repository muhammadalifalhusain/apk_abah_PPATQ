class PembayaranResponse {
  final int status;
  final String message;
  final Map<String, List<PembayaranItem>> data;

  PembayaranResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PembayaranResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>? ?? {};
    final parsedData = rawData.map((key, value) {
      final List list = value as List? ?? [];
      return MapEntry(
        key,
        list.map((item) => PembayaranItem.fromJson(item)).toList(),
      );
    });

    return PembayaranResponse(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      data: parsedData,
    );
  }
}

class PembayaranItem {
  final String pengirim;
  final String noWa;
  final String namaSantri;
  final String kelas;
  final String tanggalBayar;
  final String periode;
  final JenisPembayaran jenisPembayaran;
  final String validasi;

  PembayaranItem({
    required this.pengirim,
    required this.noWa,
    required this.namaSantri,
    required this.kelas,
    required this.tanggalBayar,
    required this.periode,
    required this.jenisPembayaran,
    required this.validasi,
  });

  factory PembayaranItem.fromJson(Map<String, dynamic> json) {
    return PembayaranItem(
      pengirim: json['pengirim']?.toString().trim() ?? '',
      noWa: json['noWa']?.toString().trim() ?? '',
      namaSantri: json['namaSantri']?.toString().trim() ?? '',
      kelas: json['kelas']?.toString().trim() ?? '',
      tanggalBayar: json['tanggalBayar']?.toString().trim() ?? '',
      periode: json['periode']?.toString().trim() ?? '',
      jenisPembayaran: JenisPembayaran.fromJson(json['jenisPembayaran'] ?? {}),
      validasi: json['validasi']?.toString().trim() ?? '',
    );
  }
}

class JenisPembayaran {
  final int spp;
  final int zarkasi;
  final int uangSaku;
  final int infaqPembangunan;
  final int cicilanDaftarUlang;
  final int arwahan;
  final int sakuZarkasi;
  final int pelunasanZarkasi;
  final int ujianAkhir;
  final int lainLain;

  JenisPembayaran({
    required this.spp,
    required this.zarkasi,
    required this.uangSaku,
    required this.infaqPembangunan,
    required this.cicilanDaftarUlang,
    required this.arwahan,
    required this.sakuZarkasi,
    required this.pelunasanZarkasi,
    required this.ujianAkhir,
    required this.lainLain,
  });

  factory JenisPembayaran.fromJson(Map<String, dynamic> json) {
    return JenisPembayaran(
      spp: _parseCurrency(json['SPP / Syahriyah']),
      zarkasi: _parseCurrency(json['Zarkasi']),
      uangSaku: _parseCurrency(json['Uang Saku / Jajan']),
      infaqPembangunan: _parseCurrency(json['Infaq Pembagunan']),
      cicilanDaftarUlang: _parseCurrency(json['Cicilan Daftar Ulang']),
      arwahan: _parseCurrency(json['Arwahan']),
      sakuZarkasi: _parseCurrency(json['Saku Zarkasi']),
      pelunasanZarkasi: _parseCurrency(json['Pelunasan Zarkasi']),
      ujianAkhir: _parseCurrency(json['Ujian Akhir Kelulusan']),
      lainLain: _parseCurrency(json['Lain-lain']),
    );
  }

  static int _parseCurrency(dynamic value) {
    if (value == null) return 0;
    final str = value.toString().replaceAll('.', '').trim();
    return int.tryParse(str) ?? 0;
  }
  Map<String, int> get entries => {
        'SPP / Syahriyah': spp,
        'Zarkasi': zarkasi,
        'Uang Saku / Jajan': uangSaku,
        'Infaq Pembagunan': infaqPembangunan,
        'Cicilan Daftar Ulang': cicilanDaftarUlang,
        'Arwahan': arwahan,
        'Saku Zarkasi': sakuZarkasi,
        'Pelunasan Zarkasi': pelunasanZarkasi,
        'Ujian Akhir Kelulusan': ujianAkhir,
        'Lain-lain': lainLain,
      };
}

