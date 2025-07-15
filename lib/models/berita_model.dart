class BeritaResponse {
  final int status;
  final String message;
  final BeritaData data;

  BeritaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BeritaResponse.fromJson(Map<String, dynamic> json) {
    return BeritaResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: BeritaData.fromJson(json['data'] ?? {}),
    );
  }
}

class BeritaData {
  final int currentPage;
  final List<BeritaItem> data;
  final int lastPage;
  final String? nextPageUrl;
  final int total;

  BeritaData({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,
    required this.total,
  });

  factory BeritaData.fromJson(Map<String, dynamic> json) {
    return BeritaData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BeritaItem.fromJson(e))
          .toList(),
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url'],
      total: json['total'] ?? 0,
    );
  }
}

class BeritaItem {
  final String judul;
  final String thumbnail;
  final String gambarDalam;
  final String isiBerita;

  BeritaItem({
    required this.judul,
    required this.thumbnail,
    required this.gambarDalam,
    required this.isiBerita,
  });

  factory BeritaItem.fromJson(Map<String, dynamic> json) {
    return BeritaItem(
      judul: json['judul'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      gambarDalam: json['gambar_dalam'] ?? '',
      isiBerita: json['isi_berita'] ?? '',
    );
  }
}
