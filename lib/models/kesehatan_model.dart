class KesehatanResponse {
  final int status;
  final String message;
  final KesehatanData data;

  KesehatanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KesehatanResponse.fromJson(Map<String, dynamic> json) {
    return KesehatanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: KesehatanData.fromJson(json['data'] ?? {}),
    );
  }
}

class KesehatanData {
  final String bulan;
  final int jumlah;

  KesehatanData({
    required this.bulan,
    required this.jumlah,
  });

  factory KesehatanData.fromJson(Map<String, dynamic> json) {
    return KesehatanData(
      bulan: json['bulan'] ?? '',
      jumlah: json['jumlah'] ?? 0,
    );
  }
}
