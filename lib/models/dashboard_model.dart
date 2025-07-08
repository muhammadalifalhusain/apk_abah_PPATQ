class DashboardResponse {
  final int status;
  final String message;
  final DashboardData? data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
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
  final int jumlahPembayaran;
  final String totalPembayaran;
  final int jumlahSantriBelumLapor;
  final String jumlahPembayaranLalu;

  DashboardData({
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
    required this.jumlahPembayaran,
    required this.totalPembayaran,
    required this.jumlahSantriBelumLapor,
    required this.jumlahPembayaranLalu,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
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
      jumlahPembayaran: json['jumlahPembayaran'] ?? 0,
      totalPembayaran: json['totalPembayaran'] ?? '0',
      jumlahSantriBelumLapor: json['jumlahSantriBelumLapor'] ?? 0,
      jumlahPembayaranLalu: json['jumlahPembayaranLalu'] ?? '0',
    );
  }
}
