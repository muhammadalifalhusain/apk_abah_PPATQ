class Santri {
  final int noInduk;
  final String photo;
  final String nama;
  final String waliKelas;
  final String jenisKelamin;
  final String kelas;
  final String asalKota;

  Santri({
    required this.noInduk,
    required this.photo,
    required this.nama,
    required this.waliKelas,
    required this.jenisKelamin,
    required this.kelas,
    required this.asalKota,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['noInduk'] ?? 0,
      photo: (json['photo'] ?? '').toString().trim(),
      nama: (json['nama'] ?? 'noInduk tidak diketahui').toString().trim(),
      waliKelas: (json['waliKelas'] ?? 'data tidak diketahui').toString().trim(),
      jenisKelamin: _mapGender(json['jenisKelamin']),
      kelas: (json['kelas'] ?? '-').toString().trim(),
      asalKota: (json['asalKota'] ?? '-').toString().trim(),
    );
  }

  static String _mapGender(dynamic value) {
    final code = value?.toString().toUpperCase();
    if (code == 'L') return 'Laki-laki';
    if (code == 'P') return 'Perempuan';
    return '-';
  }
}

class SantriPaginatedData {
  final int currentPage;
  final List<Santri> data;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;
  final int lastPage;

  SantriPaginatedData({
    required this.currentPage,
    required this.data,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.total,
    required this.lastPage,
  });

  factory SantriPaginatedData.fromJson(Map<String, dynamic> json) {
    return SantriPaginatedData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List).map((e) => Santri.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }

  factory SantriPaginatedData.empty() {
    return SantriPaginatedData(
      currentPage: 1,
      data: [],
      nextPageUrl: null,
      prevPageUrl: null,
      total: 0,
      lastPage: 1,
    );
  }
}

class SantriResponse {
  final int status;
  final String message;
  final SantriPaginatedData data;

  SantriResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SantriResponse.fromJson(Map<String, dynamic> json) {
    return SantriResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: SantriPaginatedData.fromJson(json['data']),
    );
  }
}

class SantriDetail {
  final DataDiri dataDiri;
  final List<RiwayatSakit> riwayatSakit;
  final List<Pemeriksaan> pemeriksaan;
  final List<RawatInap> rawatInap;
  final Map<String, Map<String, List<Ketahfidzan>>> ketahfidzan;
  final List<Perilaku> perilaku;
  final List<Kelengkapan> kelengkapan;
  final List<RiwayatBayar> riwayatBayar;

  SantriDetail({
    required this.dataDiri,
    required this.riwayatSakit,
    required this.pemeriksaan,
    required this.rawatInap,
    required this.ketahfidzan,
    required this.perilaku,
    required this.kelengkapan,
    required this.riwayatBayar,
  });

  factory SantriDetail.fromJson(Map<String, dynamic> json) {
    return SantriDetail(
      dataDiri: DataDiri.fromJson(json['dataDiri'] is Map ? json['dataDiri'] : {}),
      riwayatSakit: (json['riwayatSakit'] is List)
          ? (json['riwayatSakit'] as List)
              .where((e) => e != null)
              .map((e) => RiwayatSakit.fromJson(e))
              .toList()
          : [],
      pemeriksaan: (json['pemeriksaan'] is List)
          ? (json['pemeriksaan'] as List)
              .where((e) => e != null)
              .map((e) => Pemeriksaan.fromJson(e))
              .toList()
          : [],
      rawatInap: (json['rawatInap'] is List)
          ? (json['rawatInap'] as List)
              .where((e) => e != null)
              .map((e) => RawatInap.fromJson(e))
              .toList()
          : [],
      ketahfidzan: (json['ketahfidzan'] is Map)
      ? (json['ketahfidzan'] as Map<String, dynamic>).map(
          (tahun, bulanMap) {
            final bulanData = (bulanMap is Map)
                ? (bulanMap as Map<String, dynamic>).map(
                    (bulan, list) {
                      final listData = (list is List)
                          ? list
                              .where((e) => e != null)
                              .map((e) => Ketahfidzan.fromJson(e))
                              .toList()
                          : <Ketahfidzan>[];
                      return MapEntry(bulan, listData);
                    },
                  )
                : <String, List<Ketahfidzan>>{};
            return MapEntry(tahun, bulanData as Map<String, List<Ketahfidzan>>);
          },
        )
      : {},
      perilaku: (json['perilaku'] is List)
          ? (json['perilaku'] as List)
              .where((e) => e != null)
              .map((e) => Perilaku.fromJson(e))
              .toList()
          : [],
      kelengkapan: (json['kelengkapan'] is List)
          ? (json['kelengkapan'] as List)
              .where((e) => e != null)
              .map((e) => Kelengkapan.fromJson(e))
              .toList()
          : [],
      riwayatBayar: (json['riwayatBayar'] is List)
          ? (json['riwayatBayar'] as List)
              .where((e) => e != null)
              .map((e) => RiwayatBayar.fromJson(e))
              .toList()
          : [],
    );
  }
}

class DataDiri {
  final int noInduk;
  final String nama;
  final String? tanggalLahir;
  final String? tanggalLahirFormatted;
  final String? photo;
  final String? kelas;
  final String? tempatLahir;
  final String? jenisKelamin;
  final String? alamat;
  final String? kelurahan;
  final String? kecamatan;
  final String? kotaKab;
  final String? namaAyah;
  final String? pendidikanAyah;
  final String? pekerjaanAyah;
  final String? namaIbu;
  final String? pendidikanIbu;
  final String? pekerjaanIbu;
  final String? noHp;
  final String? noVa;
  final String? kelasTahfidz;
  final String? kamar;
  final String? namaMurroby;
  final String? fotoMurroby;
  final String? namaTahfidz;
  final String? fotoTahfidz;

  DataDiri({
    required this.noInduk,
    required this.nama,
    this.tanggalLahir,
    this.tanggalLahirFormatted,
    this.photo,
    this.kelas,
    this.tempatLahir,
    this.jenisKelamin,
    this.alamat,
    this.kelurahan,
    this.kecamatan,
    this.kotaKab,
    this.namaAyah,
    this.pendidikanAyah,
    this.pekerjaanAyah,
    this.namaIbu,
    this.pendidikanIbu,
    this.pekerjaanIbu,
    this.noHp,
    this.noVa,
    this.kelasTahfidz,
    this.kamar,
    this.namaMurroby,
    this.fotoMurroby,
    this.namaTahfidz,
    this.fotoTahfidz,
  });

  factory DataDiri.fromJson(Map<String, dynamic> json) {
    return DataDiri(
      noInduk: (json['noInduk'] is int) ? json['noInduk'] : 0,
      nama: (json['nama'] is String) ? json['nama'] : '',
      tanggalLahir: (json['tanggalLahir'] is String) ? json['tanggalLahir'] : null,
      tanggalLahirFormatted: (json['tanggal_lahir'] is String) ? json['tanggal_lahir'] : null,
      photo: (json['photo'] is String) ? json['photo'] : null,
      kelas: (json['kelas'] is String) ? json['kelas'] : null,
      tempatLahir: (json['tempatLahir'] is String) ? json['tempatLahir'] : null,
      jenisKelamin: (json['jenisKelamin'] is String) ? json['jenisKelamin'] : null,
      alamat: (json['alamat'] is String) ? json['alamat'] : null,
      kelurahan: (json['kelurahan'] is String) ? json['kelurahan'] : null,
      kecamatan: (json['kecamatan'] is String) ? json['kecamatan'] : null,
      kotaKab: (json['kotaKab'] is String) ? json['kotaKab'] : null,
      namaAyah: (json['namaAyah'] is String) ? json['namaAyah'] : null,
      pendidikanAyah: (json['pendidikanAyah'] is String) ? json['pendidikanAyah'] : null,
      pekerjaanAyah: (json['pekerjaanAyah'] is String) ? json['pekerjaanAyah'] : null,
      namaIbu: (json['namaIbu'] is String) ? json['namaIbu'] : null,
      pendidikanIbu: (json['pendidikanIbu'] is String) ? json['pendidikanIbu'] : null,
      pekerjaanIbu: (json['pekerjaanIbu'] is String) ? json['pekerjaanIbu'] : null,
      noHp: (json['noHp'] is String) ? json['noHp'] : null,
      noVa: (json['noVa'] is String) ? json['noVa'] : null,
      kelasTahfidz: (json['kelasTahfidz'] is String) ? json['kelasTahfidz'] : null,
      kamar: (json['kamar'] is String) ? json['kamar'] : null,
      namaMurroby: (json['namaMurroby'] is String) ? json['namaMurroby'] : null,
      fotoMurroby: (json['fotoMurroby'] is String) ? json['fotoMurroby'] : null,
      namaTahfidz: (json['namaTahfidz'] is String) ? json['namaTahfidz'] : null,
      fotoTahfidz: (json['fotoTahfidz'] is String) ? json['fotoTahfidz'] : null,
    );
  }
  String get jenisKelaminFormatted {
    if (jenisKelamin == 'L') return 'Laki-laki';
    if (jenisKelamin == 'P') return 'Perempuan';
    return '-';
  }

}

class RiwayatSakit {
  final String keluhan;
  final String? tanggalSakit;
  final String? tanggalSembuh;
  final String? keteranganSakit;
  final String? keteranganSembuh;
  final String? tindakan;

  RiwayatSakit({
    required this.keluhan,
    this.tanggalSakit,
    this.tanggalSembuh,
    this.keteranganSakit,
    this.keteranganSembuh,
    this.tindakan,
  });

  factory RiwayatSakit.fromJson(Map<String, dynamic> json) {
    return RiwayatSakit(
      keluhan: (json['keluhan'] is String) ? json['keluhan'] : 'Tidak ada keluhan',
      tanggalSakit: (json['tanggalSakit'] is String) ? json['tanggalSakit'] : null,
      tanggalSembuh: (json['tanggalSembuh'] is String) ? json['tanggalSembuh'] : null,
      keteranganSakit: (json['keteranganSakit'] is String) ? json['keteranganSakit'] : null,
      keteranganSembuh: (json['keteranganSembuh'] is String) ? json['keteranganSembuh'] : null,
      tindakan: (json['tindakan'] is String) ? json['tindakan'] : null,
    );
  }
}

class Pemeriksaan {
  final String? tanggalPemeriksaan;
  final int tinggiBadan;
  final int beratBadan;
  final int lingkarPinggul;
  final int lingkarDada;
  final String kondisiGigi;

  Pemeriksaan({
    this.tanggalPemeriksaan,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPinggul,
    required this.lingkarDada,
    required this.kondisiGigi,
  });

  factory Pemeriksaan.fromJson(Map<String, dynamic> json) {
    return Pemeriksaan(
      tanggalPemeriksaan: (json['tanggalPemeriksaan'] is String) ? json['tanggalPemeriksaan'] : null,
      tinggiBadan: (json['tinggiBadan'] is int) ? json['tinggiBadan'] : 0,
      beratBadan: (json['beratBadan'] is int) ? json['beratBadan'] : 0,
      lingkarPinggul: (json['lingkarPinggul'] is int) ? json['lingkarPinggul'] : 0,
      lingkarDada: (json['lingkarDada'] is int) ? json['lingkarDada'] : 0,
      kondisiGigi: (json['kondisiGigi'] is String) ? json['kondisiGigi'] : 'Normal',
    );
  }
}

class RawatInap {
  final String? tanggalMasuk;
  final String keluhan;
  final String? terapi;
  final String? tanggalKeluar;

  RawatInap({
    this.tanggalMasuk,
    required this.keluhan,
    this.terapi,
    this.tanggalKeluar,
  });

  factory RawatInap.fromJson(Map<String, dynamic> json) {
    return RawatInap(
      tanggalMasuk: (json['tanggalMasuk'] is String) ? json['tanggalMasuk'] : null,
      keluhan: (json['keluhan'] is String) ? json['keluhan'] : 'Tidak ada keluhan',
      terapi: (json['terapi'] is String) ? json['terapi'] : null,
      tanggalKeluar: (json['tanggalKeluar'] is String) ? json['tanggalKeluar'] : null,
    );
  }
}

class Ketahfidzan {
  final String tanggal;
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
  final String nmJuz;

  Ketahfidzan({
    required this.tanggal,
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
    required this.nmJuz,
  });

  factory Ketahfidzan.fromJson(Map<String, dynamic> json) {
    return Ketahfidzan(
      tanggal: (json['tanggal'] is String) ? json['tanggal'] : '',
      hafalan: (json['hafalan'] is String) ? json['hafalan'] : '',
      tilawah: (json['tilawah'] is String) ? json['tilawah'] : '',
      kefasihan: (json['kefasihan'] is String) ? json['kefasihan'] : '',
      dayaIngat: (json['dayaIngat'] is String) ? json['dayaIngat'] : '',
      kelancaran: (json['kelancaran'] is String) ? json['kelancaran'] : '',
      praktekTajwid: (json['praktekTajwid'] is String) ? json['praktekTajwid'] : '',
      makhroj: (json['makhroj'] is String) ? json['makhroj'] : '',
      tanafus: (json['tanafus'] is String) ? json['tanafus'] : '',
      waqofWasol: (json['waqofWasol'] is String) ? json['waqofWasol'] : '',
      ghorib: (json['ghorib'] is String) ? json['ghorib'] : '',
      nmJuz: (json['nmJuz'] is String) ? json['nmJuz'] : '',
    );
  }
}

class Perilaku {
  final String tanggal;
  final String ketertiban;
  final String kebersihan;
  final String kedisiplinan;
  final String kerapian;
  final String kesopanan;
  final String kepekaanLingkungan;
  final String ketaatanPeraturan;

  Perilaku({
    required this.tanggal,
    required this.ketertiban,
    required this.kebersihan,
    required this.kedisiplinan,
    required this.kerapian,
    required this.kesopanan,
    required this.kepekaanLingkungan,
    required this.ketaatanPeraturan,
  });

  factory Perilaku.fromJson(Map<String, dynamic> json) {
    return Perilaku(
      tanggal: (json['tanggal'] is String) ? json['tanggal'] : '',
      ketertiban: (json['ketertiban'] is String) ? json['ketertiban'] : '',
      kebersihan: (json['kebersihan'] is String) ? json['kebersihan'] : '',
      kedisiplinan: (json['kedisiplinan'] is String) ? json['kedisiplinan'] : '',
      kerapian: (json['kerapian'] is String) ? json['kerapian'] : '',
      kesopanan: (json['kesopanan'] is String) ? json['kesopanan'] : '',
      kepekaanLingkungan: (json['kepekaanLingkungan'] is String) ? json['kepekaanLingkungan'] : '',
      ketaatanPeraturan: (json['ketaatanPeraturan'] is String) ? json['ketaatanPeraturan'] : '',
    );
  }
}

class Kelengkapan {
  final String tanggal;
  final String perlengkapanMandi;
  final String catatanMandi;
  final String peralatanSekolah;
  final String catatanSekolah;
  final String perlengkapanDiri;
  final String catatanDiri;

  Kelengkapan({
    required this.tanggal,
    required this.perlengkapanMandi,
    required this.catatanMandi,
    required this.peralatanSekolah,
    required this.catatanSekolah,
    required this.perlengkapanDiri,
    required this.catatanDiri,
  });

  factory Kelengkapan.fromJson(Map<String, dynamic> json) {
    return Kelengkapan(
      tanggal: (json['tanggal'] is String) ? json['tanggal'] : '',
      perlengkapanMandi: (json['perlengkapanMandi'] is String) ? json['perlengkapanMandi'] : '',
      catatanMandi: (json['catatanMandi'] is String) ? json['catatanMandi'] : '',
      peralatanSekolah: (json['peralatanSekolah'] is String) ? json['peralatanSekolah'] : '',
      catatanSekolah: (json['catatanSekolah'] is String) ? json['catatanSekolah'] : '',
      perlengkapanDiri: (json['perlengkapanDiri'] is String) ? json['perlengkapanDiri'] : '',
      catatanDiri: (json['catatanDiri'] is String) ? json['catatanDiri'] : '',
    );
  }
}

class RiwayatBayar {
  final String tanggalBayar;
  final String periode;
  final Map<String, String> jenisPembayaran;
  final String validasi;

  RiwayatBayar({
    required this.tanggalBayar,
    required this.periode,
    required this.jenisPembayaran,
    required this.validasi,
  });

  factory RiwayatBayar.fromJson(Map<String, dynamic> json) {
    return RiwayatBayar(
      tanggalBayar: (json['tanggalBayar'] is String) ? json['tanggalBayar'] : '',
      periode: (json['periode'] is String) ? json['periode'] : '',
      jenisPembayaran: (json['jenisPembayaran'] is Map)
          ? Map<String, String>.from(json['jenisPembayaran'])
          : {},
      validasi: (json['validasi'] is String) ? json['validasi'] : '',
    );
  }
}
