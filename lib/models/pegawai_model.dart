class PegawaiData {
  final int id;
  final String photo;
  final String nama;
  final String jenisKelamin;

  PegawaiData({
    required this.id,
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
  });

  factory PegawaiData.fromJson(Map<String, dynamic> json) {
    return PegawaiData(
      id: json['id'] ?? 0,
      photo: (json['photo'] ?? '').toString().isNotEmpty
          ? json['photo']
          : 'default.png',
      nama: (json['nama'] ?? 'Tidak diketahui').toString(),
      jenisKelamin: (json['jenisKelamin'] ?? 'Tidak diketahui').toString(),
    );
  }
}

class PegawaiPaginatedData {
  final int currentPage;
  final List<PegawaiData> data;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;
  final int lastPage;

  PegawaiPaginatedData({
    required this.currentPage,
    required this.data,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.total,
    required this.lastPage,
  });

  factory PegawaiPaginatedData.fromJson(Map<String, dynamic> json) {
    return PegawaiPaginatedData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List).map((e) => PegawaiData.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }

  factory PegawaiPaginatedData.empty() {
    return PegawaiPaginatedData(
      currentPage: 1,
      data: [],
      nextPageUrl: null,
      prevPageUrl: null,
      total: 0,
      lastPage: 1,
    );
  }
}

class PegawaiResponse {
  final int status;
  final String message;
  final PegawaiPaginatedData data;

  PegawaiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PegawaiResponse.fromJson(Map<String, dynamic> json) {
    return PegawaiResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: PegawaiPaginatedData.fromJson(json['data']),
    );
  }
}
