class Kurban {
  final String namaSantri;
  final String atasNama;
  final String jenis;
  final String tanggal;

  Kurban({
    required this.namaSantri,
    required this.atasNama,
    required this.jenis,
    required this.tanggal,
  });

  factory Kurban.fromJson(Map<String, dynamic> json) {
    return Kurban(
      namaSantri: (json['namaSantri'] ?? '').toString().trim().isNotEmpty
          ? json['namaSantri']
          : '-',
      atasNama: (json['atasNama'] ?? '').toString().trim().isNotEmpty
          ? json['atasNama']
          : '-',
      jenis: (json['jenis'] ?? '').toString().trim().isNotEmpty
          ? json['jenis']
          : '-',
      tanggal: (json['tanggal'] ?? '').toString().trim().isNotEmpty
          ? json['tanggal']
          : '-',
    );
  }
}

class KurbanResponse {
  final int status;
  final String message;
  final List<Kurban> data;

  KurbanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KurbanResponse.fromJson(Map<String, dynamic> json) {
    return KurbanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => Kurban.fromJson(item))
          .toList(),
    );
  }
}
