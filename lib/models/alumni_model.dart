class AlumniResponse {
  final int status;
  final String message;
  final int jumlah;
  final AlumniData data;

  AlumniResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory AlumniResponse.fromJson(Map<String, dynamic> json) {
    return AlumniResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: AlumniData.fromJson(json['data'] ?? {}),
    );
  }
}

class AlumniData {
  final int currentPage;
  final List<AlumniItem> data;
  final int lastPage;
  final String? nextPageUrl;
  final int total;

  AlumniData({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,
    required this.total,
  });

  factory AlumniData.fromJson(Map<String, dynamic> json) {
    return AlumniData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AlumniItem.fromJson(e))
          .toList(),
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url'],
      total: json['total'] ?? 0,
    );
  }
}

class AlumniItem {
  final int noInduk;
  final String nama;
  final String? noHp;
  final String murroby;
  final String waliKelas;
  final int? tahunLulus;
  final int? tahunMasukMi;
  final String? namaPondokMi;
  final int? tahunMasukMenengah;
  final String? namaSekolahMenengah;
  final int? tahunMasukMenengahAtas;
  final String? namaPondokMenengahAtas;
  final int? tahunMasukPerguruanTinggi;
  final String? namaPerguruanTinggi;
  final String? namaPondokPerguruanTinggi;
  final int? tahunMasukProfesi;
  final String? namaPerusahaan;
  final String? bidangProfesi;
  final String? posisiProfesi;

  AlumniItem({
    required this.noInduk,
    required this.nama,
    this.noHp,
    required this.murroby,
    required this.waliKelas,
    this.tahunLulus,
    this.tahunMasukMi,
    this.namaPondokMi,
    this.tahunMasukMenengah,
    this.namaSekolahMenengah,
    this.tahunMasukMenengahAtas,
    this.namaPondokMenengahAtas,
    this.tahunMasukPerguruanTinggi,
    this.namaPerguruanTinggi,
    this.namaPondokPerguruanTinggi,
    this.tahunMasukProfesi,
    this.namaPerusahaan,
    this.bidangProfesi,
    this.posisiProfesi,
  });

  factory AlumniItem.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic val) {
      if (val == null || (val is String && val.trim().isEmpty)) return null;
      return val.toString();
    }

    int? parseInt(dynamic val) {
      if (val == null || val.toString().trim().isEmpty) return null;
      return int.tryParse(val.toString());
    }

    return AlumniItem(
      noInduk: json['noInduk'] ?? 0,
      nama: json['nama'] ?? '',
      noHp: parseString(json['noHp']),
      murroby: json['murroby'] ?? '',
      waliKelas: json['waliKelas'] ?? '',
      tahunLulus: parseInt(json['tahunLulus']),
      tahunMasukMi: parseInt(json['tahunMasukMi']),
      namaPondokMi: parseString(json['namaPondokMi']),
      tahunMasukMenengah: parseInt(json['tahunMasukMenengah']),
      namaSekolahMenengah: parseString(json['namaSekolahMenengah']),
      tahunMasukMenengahAtas: parseInt(json['tahunMasukMenengahAtas']),
      namaPondokMenengahAtas: parseString(json['namaPondokMenengahAtas']),
      tahunMasukPerguruanTinggi: parseInt(json['tahunMasukPearguruanTinggi']),
      namaPerguruanTinggi: parseString(json['namaPerguruanTinggi']),
      namaPondokPerguruanTinggi: parseString(json['namaPondokPerguruanTinggi']),
      tahunMasukProfesi: parseInt(json['tahunMasukProfesi']),
      namaPerusahaan: parseString(json['namaPerusahaan']),
      bidangProfesi: parseString(json['bidangProfesi']),
      posisiProfesi: parseString(json['posisiProfesi']),
    );
  }
}
