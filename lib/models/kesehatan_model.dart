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
  final String jenisSakitDialami;
  final int jumlahSantriSakit;
  final List<SantriSakit> daftarSantriSakit;
  final List<ResumeKelas> resumeKelas;

  KesehatanData({
    required this.bulan,
    required this.jenisSakitDialami,
    required this.jumlahSantriSakit,
    required this.daftarSantriSakit,
    required this.resumeKelas,
  });

  factory KesehatanData.fromJson(Map<String, dynamic> json) {
    return KesehatanData(
      bulan: json['bulan'] ?? '',
      jenisSakitDialami: json['jenisSakitDialami'] ?? '',
      jumlahSantriSakit: json['jumlahSantriSakit'] ?? 0,
      daftarSantriSakit: (json['daftarSantriSakit'] as List<dynamic>?)
              ?.map((e) => SantriSakit.fromJson(e))
              .toList() ??
          [],
      resumeKelas: (json['resumeKelas'] as List<dynamic>?)
              ?.map((e) => ResumeKelas.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SantriSakit {
  final String nama;
  final int jumlah;

  SantriSakit({
    required this.nama,
    required this.jumlah,
  });

  factory SantriSakit.fromJson(Map<String, dynamic> json) {
    return SantriSakit(
      nama: json['nama'] ?? '',
      jumlah: json['jumlah'] ?? 0,
    );
  }
}

class ResumeKelas {
  final String kelas;
  final List<DetailSantriKelas> data;

  ResumeKelas({
    required this.kelas,
    required this.data,
  });

  factory ResumeKelas.fromJson(Map<String, dynamic> json) {
    return ResumeKelas(
      kelas: json['kelas'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DetailSantriKelas.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DetailSantriKelas {
  final String kodeKelas;
  final String nama;
  final String? tanggalSakit;
  final String? sakit;
  final String? tindakan;
  final String? tanggalMasukRawatInap;
  final String? keluhan;
  final String? terapi;
  final String? tanggalKeluarRawatInap;
  final String? namaMurroby;

  DetailSantriKelas({
    required this.kodeKelas,
    required this.nama,
    this.tanggalSakit,
    this.sakit,
    this.tindakan,
    this.tanggalMasukRawatInap,
    this.keluhan,
    this.terapi,
    this.tanggalKeluarRawatInap,
    this.namaMurroby,
  });

  factory DetailSantriKelas.fromJson(Map<String, dynamic> json) {
    return DetailSantriKelas(
      kodeKelas: json['kodeKelas'] ?? '',
      nama: json['nama'] ?? '',
      tanggalSakit: json['tanggalSakit'],
      sakit: json['sakit'],
      tindakan: json['tindakan'],
      tanggalMasukRawatInap: json['tanggalMasukRawatInap'],
      keluhan: json['keluhan'],
      terapi: json['terapi'],
      tanggalKeluarRawatInap: json['tanggalKeluarRawatInap'],
      namaMurroby: json['namaMurroby'],
    );
  }
}
