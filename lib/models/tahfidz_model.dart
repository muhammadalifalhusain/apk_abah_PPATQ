class KelasTahfidz {
  final int id;
  final String namaKelas;
  final String guruTahfidz;

  KelasTahfidz({
    required this.id,
    required this.namaKelas,
    required this.guruTahfidz,
  });

  factory KelasTahfidz.fromJson(Map<String, dynamic> json) {
    return KelasTahfidz(
      id: json['id'] ?? 0,
      namaKelas: json['namaKelas'] ?? '-',
      guruTahfidz: json['guruTahfidz'] ?? '-',
    );
  }
}

class KelasTahfidzResponse {
  final int status;
  final String message;
  final List<KelasTahfidz> data;

  KelasTahfidzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KelasTahfidzResponse.fromJson(Map<String, dynamic> json) {
    return KelasTahfidzResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => KelasTahfidz.fromJson(item))
          .toList(),
    );
  }
}

class SantriTahfidz {
  final int noInduk;
  final String nama;
  final String jenisKelamin;
  final String? photo;
  final String? capaianTerakhir;

  SantriTahfidz({
    required this.noInduk,
    required this.nama,
    required this.jenisKelamin,
    this.photo,
    this.capaianTerakhir,
  });

  factory SantriTahfidz.fromJson(Map<String, dynamic> json) {
    return SantriTahfidz(
      noInduk: json['noInduk'] ?? 0,
      nama: json['nama'] ?? '-',
      jenisKelamin: json['jenisKelamin'] ?? '-',
      photo: json['photo'],
      capaianTerakhir: json['capaianTerakhir'],
    );
  }
}

class CapaianTertinggi {
  final String capaian;
  final int jumlahSantri;
  final List<SantriTertinggi> listSantriTertinggi;

  CapaianTertinggi({
    required this.capaian,
    required this.jumlahSantri,
    required this.listSantriTertinggi,
  });

  factory CapaianTertinggi.fromJson(Map<String, dynamic> json) {
    return CapaianTertinggi(
      capaian: json['capaian'] ?? '-',
      jumlahSantri: json['jumlahSantri'] ?? 0,
      listSantriTertinggi: (json['listSantriTertinggi'] as List)
          .map((e) => SantriTertinggi.fromJson(e))
          .toList(),
    );
  }
}

class SantriTertinggi {
  final String namaSantri;
  final String? photo;

  SantriTertinggi({
    required this.namaSantri,
    this.photo,
  });

  factory SantriTertinggi.fromJson(Map<String, dynamic> json) {
    return SantriTertinggi(
      namaSantri: json['namaSantri'] ?? '-',
      photo: json['photo'],
    );
  }
}

class DataTahfidzDetail {
  final String namaGuruTahfidz;
  final String fotoGuruTahfidz;
  final String namaKelasTahfidz;

  DataTahfidzDetail({
    required this.namaGuruTahfidz,
    required this.fotoGuruTahfidz,
    required this.namaKelasTahfidz,
  });

  factory DataTahfidzDetail.fromJson(Map<String, dynamic> json) {
    return DataTahfidzDetail(
      namaGuruTahfidz: json['namaGuruTahfidz'] ?? '-',
      fotoGuruTahfidz: json['fotoGuruTahfidz'] ?? '',
      namaKelasTahfidz: json['namaKelasTahfidz'] ?? '-',
    );
  }
}

class TahfidzDetailData {
  final DataTahfidzDetail? dataTahfidz;
  final CapaianTertinggi? capaianTertinggi;
  final List<SantriTahfidz> santri;

  TahfidzDetailData({
    required this.dataTahfidz,
    required this.capaianTertinggi,
    required this.santri,
  });

  factory TahfidzDetailData.fromJson(Map<String, dynamic> json) {
    return TahfidzDetailData(
      dataTahfidz: json['dataTahfidz'] != null
          ? DataTahfidzDetail.fromJson(json['dataTahfidz'])
          : null,
      capaianTertinggi: json['capaianTertinggi'] != null
          ? CapaianTertinggi.fromJson(json['capaianTertinggi'])
          : null,
      santri: (json['santri'] as List)
          .map((e) => SantriTahfidz.fromJson(e))
          .toList(),
    );
  }
}

class TahfidzDetailResponse {
  final int status;
  final String message;
  final int jumlah;
  final TahfidzDetailData data;

  TahfidzDetailResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory TahfidzDetailResponse.fromJson(Map<String, dynamic> json) {
    return TahfidzDetailResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: TahfidzDetailData.fromJson(json['data']),
    );
  }
}

class SantriHafalanResponse {
  final int status;
  final String message;
  final SantriHafalanData data;

  SantriHafalanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SantriHafalanResponse.fromJson(Map<String, dynamic> json) {
    return SantriHafalanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: SantriHafalanData.fromJson(json['data'] ?? {}),
    );
  }
}

class SantriHafalanData {
  final String namaSantri;
  final List<HafalanItem> data;

  SantriHafalanData({
    required this.namaSantri,
    required this.data,
  });

  factory SantriHafalanData.fromJson(Map<String, dynamic> json) {
    return SantriHafalanData(
      namaSantri: (json['namaSantri'] ?? '').toString(),
      data: (json['data'] as List? ?? [])
          .map((item) => HafalanItem.fromJson(item ?? {}))
          .toList(),
    );
  }
}

class HafalanItem {
  final int bulan;
  final int tahun;
  final String juz;
  final String hafalan;
  final String tilawah;
  final String kefasihan;
  final String dayaIngat;
  final String kelancaran;
  final String praktekTajwid;
  final String makhroj;
  final String tanafus;
  final String waqofWasol;
  final String ghorib;
  final String namaBulan;

  HafalanItem({
    required this.bulan,
    required this.tahun,
    required this.juz,
    required this.hafalan,
    required this.tilawah,
    required this.kefasihan,
    required this.dayaIngat,
    required this.kelancaran,
    required this.praktekTajwid,
    required this.makhroj,
    required this.tanafus,
    required this.waqofWasol,
    required this.ghorib,
    required this.namaBulan,
  });

  factory HafalanItem.fromJson(Map<String, dynamic> json) {
    return HafalanItem(
      bulan: _parseInt(json['bulan']),
      tahun: _parseInt(json['tahun']),
      juz: _safeString(json['juz']),
      hafalan: _safeString(json['hafalan']),
      tilawah: _safeString(json['tilawah']),
      kefasihan: _safeString(json['kefasihan']),
      dayaIngat: _safeString(json['dayaIngat']),
      kelancaran: _safeString(json['kelancaran']),
      praktekTajwid: _safeString(json['praktekTajwid']),
      makhroj: _safeString(json['makhroj']),
      tanafus: _safeString(json['tanafus']),
      waqofWasol: _safeString(json['waqofWasol']),
      ghorib: _safeString(json['ghorib']),
      namaBulan: _safeString(json['namaBulan']),
    );
  }

  static String _safeString(dynamic value) {
    final str = value?.toString().trim();
    return (str == null || str.isEmpty) ? '-' : str;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
