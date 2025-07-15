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
      data: AlumniData.fromJson(json['data']),
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
      data: (json['data'] as List<dynamic>)
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
  final String? angkatan;

  AlumniItem({
    required this.noInduk,
    required this.nama,
    this.noHp,
    required this.murroby,
    required this.waliKelas,
    this.angkatan,
  });

  factory AlumniItem.fromJson(Map<String, dynamic> json) {
    return AlumniItem(
      noInduk: json['noInduk'] ?? 0,
      nama: json['nama'] ?? '',
      noHp: json['noHp'],
      murroby: json['murroby'] ?? '',
      waliKelas: json['waliKelas'] ?? '',
      angkatan: json['angkatan'],
    );
  }
}
