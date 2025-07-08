class BelumLaporResponse {
  final int status;
  final String message;
  final List<BelumLaporData> data;

  BelumLaporResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BelumLaporResponse.fromJson(Map<String, dynamic> json) {
    return BelumLaporResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BelumLaporData.fromJson(e))
          .toList(),
    );
  }
}

class BelumLaporData {
  final String photo;
  final int noInduk;
  final String nama;

  BelumLaporData({
    required this.photo,
    required this.noInduk,
    required this.nama,
  });

  factory BelumLaporData.fromJson(Map<String, dynamic> json) {
    return BelumLaporData(
      photo: (json['photo'] ?? '').toString(),
      noInduk: json['noInduk'] is int
          ? json['noInduk']
          : int.tryParse(json['noInduk'].toString()) ?? 0,
      nama: (json['nama'] ?? '').toString(),
    );
  }
}
