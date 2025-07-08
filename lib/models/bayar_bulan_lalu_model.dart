class BayarBulanLaluResponse {
  final int status;
  final String message;
  final List<BayarBulanLalu> data;

  BayarBulanLaluResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BayarBulanLaluResponse.fromJson(Map<String, dynamic> json) {
    return BayarBulanLaluResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BayarBulanLalu.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class BayarBulanLalu {
  final String noInduk;
  final String namaSantri;
  final int jumlah;
  final String catatan;
  final String atasNama;

  BayarBulanLalu({
    required this.noInduk,
    required this.namaSantri,
    required this.jumlah,
    required this.catatan,
    required this.atasNama,
  });

  factory BayarBulanLalu.fromJson(Map<String, dynamic> json) {
    return BayarBulanLalu(
      noInduk: json['noInduk'] ?? '',
      namaSantri: json['namaSantri'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      catatan: json['catatan'] ?? '',
      atasNama: json['atasNama'] ?? '',
    );
  }
}
