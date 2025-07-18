class KelengkapanResponse {
  final int status;
  final String message;
  final KelengkapanData data;

  KelengkapanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KelengkapanResponse.fromJson(Map<String, dynamic> json) {
    return KelengkapanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: KelengkapanData.fromJson(json['data'] ?? {}),
    );
  }
}

class KelengkapanData {
  final String bulan;
  final List<KelengkapanItem> listData;

  KelengkapanData({
    required this.bulan,
    required this.listData,
  });

  factory KelengkapanData.fromJson(Map<String, dynamic> json) {
    return KelengkapanData(
      bulan: json['bulan'] ?? '',
      listData: (json['listData'] as List? ?? [])
          .map((e) => KelengkapanItem.fromJson(e ?? {}))
          .toList(),
    );
  }
}

class KelengkapanItem {
  final int mandiTidakLengkap;
  final int mandiLengkapKurang;
  final int mandiLengkapBaik;
  final int sekolahTidakLengkap;
  final int sekolahLengkapKurang;
  final int sekolahLengkapBaik;
  final int diriTidakLengkap;
  final int diriLengkapKurang;
  final int diriLengkapBaik;

  KelengkapanItem({
    required this.mandiTidakLengkap,
    required this.mandiLengkapKurang,
    required this.mandiLengkapBaik,
    required this.sekolahTidakLengkap,
    required this.sekolahLengkapKurang,
    required this.sekolahLengkapBaik,
    required this.diriTidakLengkap,
    required this.diriLengkapKurang,
    required this.diriLengkapBaik,
  });

  factory KelengkapanItem.fromJson(Map<String, dynamic> json) {
    int parse(String? value) {
      if (value == null || value.trim().isEmpty) return 0;
      return int.tryParse(value) ?? 0;
    }

    return KelengkapanItem(
      mandiTidakLengkap: parse(json['mandiTidakLengkap']),
      mandiLengkapKurang: parse(json['mandiLengkapKurang']),
      mandiLengkapBaik: parse(json['mandiLengkapBaik']),
      sekolahTidakLengkap: parse(json['sekolahTidakLengkap']),
      sekolahLengkapKurang: parse(json['sekolahLengkapKurang']),
      sekolahLengkapBaik: parse(json['sekolahLengkapBaik']),
      diriTidakLengkap: parse(json['diriTidakLengkap']),
      diriLengkapKurang: parse(json['diriLengkapKurang']),
      diriLengkapBaik: parse(json['diriLengkapBaik']),
    );
  }
}
