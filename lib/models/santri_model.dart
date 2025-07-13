class Santri {
  final int noInduk;
  final String photo;
  final String nama;
  final String jenisKelamin;
  final String kelas;

  Santri({
    required this.noInduk,
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
    required this.kelas,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['noInduk'] ?? 0,
      photo: (json['photo'] ?? '').toString().trim(),
      nama: (json['nama'] ?? 'noInduk tidak diketahui').toString().trim(),
      jenisKelamin: _mapGender(json['jenisKelamin']),
      kelas: (json['kelas'] ?? '-').toString().trim(),
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
