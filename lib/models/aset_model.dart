class AsetRuang {
  final String nama;
  final int lantai;
  final String gedung;
  final String jenisRuang;

  AsetRuang({
    required this.nama,
    required this.lantai,
    required this.gedung,
    required this.jenisRuang,
  });

  factory AsetRuang.fromJson(Map<String, dynamic> json) {
    return AsetRuang(
      nama: (json['nama'] ?? '').toString().trim().isEmpty ? '-' : json['nama'],
      lantai: json['lantai'] is int ? json['lantai'] : int.tryParse('${json['lantai']}') ?? 0,
      gedung: (json['gedung'] ?? '').toString().trim().isEmpty ? '-' : json['gedung'],
      jenisRuang: (json['jenisRuang'] ?? '').toString().trim().isEmpty ? '-' : json['jenisRuang'],
    );
  }
}

class AsetBarang {
  final String ruang;
  final String jenisBarang;
  final String nama;
  final String statusBarang;

  AsetBarang({
    required this.ruang,
    required this.jenisBarang,
    required this.nama,
    required this.statusBarang,
  });

  factory AsetBarang.fromJson(Map<String, dynamic> json) {
    return AsetBarang(
      ruang: (json['ruang'] ?? '').toString().trim().isEmpty ? '-' : json['ruang'],
      jenisBarang: (json['jenisBarang'] ?? '').toString().trim().isEmpty ? '-' : json['jenisBarang'],
      nama: (json['nama'] ?? '').toString().trim().isEmpty ? '-' : json['nama'],
      statusBarang: (json['statusBarang'] ?? '').toString().trim().isEmpty ? '-' : json['statusBarang'],
    );
  }
}

class AsetTanah {
  final String nama;
  final String alamat;
  final double luas;
  final String noSertifikat;
  final String statusTanah;

  AsetTanah({
    required this.nama,
    required this.alamat,
    required this.luas,
    required this.noSertifikat,
    required this.statusTanah,
  });

  factory AsetTanah.fromJson(Map<String, dynamic> json) {
    return AsetTanah(
      nama: (json['nama'] ?? '').toString().trim().isEmpty ? '-' : json['nama'],
      alamat: (json['alamat'] ?? '').toString().trim().isEmpty ? '-' : json['alamat'],
      luas: (json['luas'] ?? 0).toDouble(),
      noSertifikat: (json['noSertifikat'] ?? '').toString().trim().isEmpty ? '-' : json['noSertifikat'],
      statusTanah: (json['statusTanah'] ?? '').toString().trim().isEmpty ? '-' : json['statusTanah'],
    );
  }
}

class AsetResponse {
  final List<AsetRuang> asetRuang;
  final List<AsetBarang> asetBarang;
  final List<AsetTanah> asetTanah;

  AsetResponse({
    required this.asetRuang,
    required this.asetBarang,
    required this.asetTanah,
  });

  factory AsetResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return AsetResponse(
      asetRuang: (data['asetRuang'] as List?)?.map((e) => AsetRuang.fromJson(e)).toList() ?? [],
      asetBarang: (data['asetBarang'] as List?)?.map((e) => AsetBarang.fromJson(e)).toList() ?? [],
      asetTanah: (data['asetTanah'] as List?)?.map((e) => AsetTanah.fromJson(e)).toList() ?? [],
    );
  }

  factory AsetResponse.empty() {
    return AsetResponse(asetRuang: [], asetBarang: [], asetTanah: []);
  }
}
