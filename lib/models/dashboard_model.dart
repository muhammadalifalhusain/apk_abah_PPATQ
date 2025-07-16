class DashboardResponse {
  final int status;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
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
  final int jumlahSantriBelumLapor;
  final String jumlahPembayaranLalu;

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
    required this.jumlahSantriBelumLapor,
    required this.jumlahPembayaranLalu,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      bulanIni: json['bulanIni'] ?? '',
      totalTagihanSyahriah: json['totalTagihanSyahriah'] ?? '',
      jumlahPsbTahunLalu: json['jumlahPsbTahunLalu'] ?? 0,
      jumlahPsb: json['jumlahPsb'] ?? 0,
      jumlahPsbLaki: json['jumlahPsbLaki'] ?? 0,
      jumlahPsbPerempuan: json['jumlahPsbPerempuan'] ?? 0,
      jumlahSantri: json['jumlahSantri'] ?? 0,
      jumlahSantriLaki: json['jumlahSantriLaki'] ?? 0,
      jumlahSantriPerempuan: json['jumlahSantriPerempuan'] ?? 0,
      jumlahPegawai: json['jumlahPegawai'] ?? 0,
      jumlahPegawaiLaki: json['jumlahPegawaiLaki'] ?? 0,
      jumlahPegawaiPerempuan: json['jumlahPegawaiPerempuan'] ?? 0,
      totalPembayaranValidBulanIni: json['totalPembayaranValidBulanIni'] ?? '',
      jumlahSantriBelumLapor: json['jumlahSantriBelumLapor'] ?? 0,
      jumlahPembayaranLalu: json['jumlahPembayaranLalu'] ?? '',
    );
  }
}
