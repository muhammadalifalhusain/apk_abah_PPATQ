class DashboardResponse {
  final int status;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DashboardResponse(
        status: 0,
        message: 'No data',
        data: DashboardData.empty(),
      );
    }

    return DashboardResponse(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class DashboardData {
  final String bulanIni;
  final String totalTagihanSyahriah;
  final int jumlahPsbTahunLalu;
  final int jumlahPsb;
  final int jumlahPsbLaki;
  final int jumlahPsbPerempuan;
  final int jumlahSantri;
  final int jumlahSantriLaki;
  final int jumlahSantriPerempuan;
  final int jumlahPegawai;
  final int jumlahPegawaiLaki;
  final int jumlahPegawaiPerempuan;
  final String totalPembayaranValidBulanIni;
  final String totalPembayaranUnvalidBulanIni;
  final int jumlahSantriBelumLapor;
  final String jumlahPembayaranLalu;
  final int tunggakan;
  final Tahfidzan tahfidzan;

  DashboardData({
    required this.bulanIni,
    required this.totalTagihanSyahriah,
    required this.jumlahPsbTahunLalu,
    required this.jumlahPsb,
    required this.jumlahPsbLaki,
    required this.jumlahPsbPerempuan,
    required this.jumlahSantri,
    required this.jumlahSantriLaki,
    required this.jumlahSantriPerempuan,
    required this.jumlahPegawai,
    required this.jumlahPegawaiLaki,
    required this.jumlahPegawaiPerempuan,
    required this.totalPembayaranValidBulanIni,
    required this.totalPembayaranUnvalidBulanIni,
    required this.jumlahSantriBelumLapor,
    required this.jumlahPembayaranLalu,
    required this.tunggakan,
    required this.tahfidzan,
  });

  factory DashboardData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DashboardData(
      bulanIni: json['bulanIni'] as String? ?? '',
      totalTagihanSyahriah: json['totalTagihanSyahriah'] as String? ?? '0',
      jumlahPsbTahunLalu: json['jumlahPsbTahunLalu'] as int? ?? 0,
      jumlahPsb: json['jumlahPsb'] as int? ?? 0,
      jumlahPsbLaki: json['jumlahPsbLaki'] as int? ?? 0,
      jumlahPsbPerempuan: json['jumlahPsbPerempuan'] as int? ?? 0,
      jumlahSantri: json['jumlahSantri'] as int? ?? 0,
      jumlahSantriLaki: json['jumlahSantriLaki'] as int? ?? 0,
      jumlahSantriPerempuan: json['jumlahSantriPerempuan'] as int? ?? 0,
      jumlahPegawai: json['jumlahPegawai'] as int? ?? 0,
      jumlahPegawaiLaki: json['jumlahPegawaiLaki'] as int? ?? 0,
      jumlahPegawaiPerempuan: json['jumlahPegawaiPerempuan'] as int? ?? 0,
      totalPembayaranValidBulanIni:
          json['totalPembayaranValidBulanIni'] as String? ?? '0',
      totalPembayaranUnvalidBulanIni:
          json['totalPembayaranUnvalidBulanIni'] as String? ?? '0',
      jumlahSantriBelumLapor: json['jumlahSantriBelumLapor'] as int? ?? 0,
      jumlahPembayaranLalu: json['jumlahPembayaranLalu'] as String? ?? '0',
      tunggakan: json['tunggakan'] as int? ?? 0,
      tahfidzan:
          Tahfidzan.fromJson(json['tahfidzan'] as Map<String, dynamic>? ?? {}),
    );
  }

  factory DashboardData.empty() {
    return DashboardData(
      bulanIni: '',
      totalTagihanSyahriah: '0',
      jumlahPsbTahunLalu: 0,
      jumlahPsb: 0,
      jumlahPsbLaki: 0,
      jumlahPsbPerempuan: 0,
      jumlahSantri: 0,
      jumlahSantriLaki: 0,
      jumlahSantriPerempuan: 0,
      jumlahPegawai: 0,
      jumlahPegawaiLaki: 0,
      jumlahPegawaiPerempuan: 0,
      totalPembayaranValidBulanIni: '0',
      totalPembayaranUnvalidBulanIni: '0',
      jumlahSantriBelumLapor: 0,
      jumlahPembayaranLalu: '0',
      tunggakan: 0,
      tahfidzan: Tahfidzan.empty(),
    );
  }
}

class Tahfidzan {
  final Capaian? tertinggi;
  final Capaian? terendah;

  Tahfidzan({
    required this.tertinggi,
    required this.terendah,
  });

  factory Tahfidzan.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Tahfidzan(
      tertinggi: json['tertinggi'] != null
          ? Capaian.fromJson(json['tertinggi'] as Map<String, dynamic>)
          : null,
      terendah: json['terendah'] != null
          ? Capaian.fromJson(json['terendah'] as Map<String, dynamic>)
          : null,
    );
  }

  factory Tahfidzan.empty() {
    return Tahfidzan(
      tertinggi: Capaian.empty(),
      terendah: Capaian.empty(),
    );
  }
}

class Capaian {
  final String capaian;
  final int jumlah;
  final List<Santri> santri;

  Capaian({
    required this.capaian,
    required this.jumlah,
    required this.santri,
  });

  factory Capaian.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Capaian(
      capaian: json['capaian'] as String? ?? '',
      jumlah: json['jumlah'] as int? ?? 0,
      santri: (json['santri'] as List<dynamic>? ?? [])
          .map((e) => Santri.fromJson(e as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }

  factory Capaian.empty() {
    return Capaian(
      capaian: '',
      jumlah: 0,
      santri: [],
    );
  }
}

class Santri {
  final String nama;
  final String? photo;
  final String? kelas;
  final String? guruTahfidz;

  Santri({
    required this.nama,
    this.photo,
    this.kelas,
    this.guruTahfidz,
  });

  factory Santri.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Santri(
      nama: json['nama'] as String? ?? '',
      photo: json['photo'] as String?,
      kelas: json['kelas'] as String?,
      guruTahfidz: json['guruTahfidz'] as String?,
    );
  }
}
