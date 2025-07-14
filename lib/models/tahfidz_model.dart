class KelasTahfidz {
  final int id;
  final String namaKelas;
  final String guruTahfidz;

  KelasTahfidz({
    required this.id,
    required this.namaKelas,
    required this.guruTahfidz,
  });

  factory KelasTahfidz.fromJson(Map<String, dynamic> json) {
    return KelasTahfidz(
      id: json['id'] ?? 0,
      namaKelas: json['namaKelas'] ?? '-',
      guruTahfidz: json['guruTahfidz'] ?? '-',
    );
  }
}

class KelasTahfidzResponse {
  final int status;
  final String message;
  final List<KelasTahfidz> data;

  KelasTahfidzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KelasTahfidzResponse.fromJson(Map<String, dynamic> json) {
    return KelasTahfidzResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => KelasTahfidz.fromJson(item))
          .toList(),
    );
  }
}

class SantriTahfidz {
  final String nama;
  final String jenisKelamin;
  final String photo;

  SantriTahfidz({
    required this.nama,
    required this.jenisKelamin,
    required this.photo,
  });

  factory SantriTahfidz.fromJson(Map<String, dynamic> json) {
    return SantriTahfidz(
      nama: json['nama'] ?? '-',
      jenisKelamin: json['jenisKelamin'] ?? '-',
      photo: json['photo'] ?? '',
    );
  }
}

class DataTahfidzDetail {
  final String namaGuruTahfidz;
  final String fotoGuruTahfidz;
  final String namaKelasTahfidz;

  DataTahfidzDetail({
    required this.namaGuruTahfidz,
    required this.fotoGuruTahfidz,
    required this.namaKelasTahfidz,
  });

  factory DataTahfidzDetail.fromJson(Map<String, dynamic> json) {
    return DataTahfidzDetail(
      namaGuruTahfidz: json['namaGuruTahfidz'] ?? '-',
      fotoGuruTahfidz: json['fotoGuruTahfidz'] ?? '',
      namaKelasTahfidz: json['namaKelasTahfidz'] ?? '-',
    );
  }
}

class TahfidzDetailData {
  final DataTahfidzDetail? dataTahfidz;
  final List<SantriTahfidz> santri;

  TahfidzDetailData({
    required this.dataTahfidz,
    required this.santri,
  });

  factory TahfidzDetailData.fromJson(Map<String, dynamic> json) {
    return TahfidzDetailData(
      dataTahfidz: json['dataTahfidz'] != null
          ? DataTahfidzDetail.fromJson(json['dataTahfidz'])
          : null,
      santri: (json['santri'] as List)
          .map((e) => SantriTahfidz.fromJson(e))
          .toList(),
    );
  }
}

class TahfidzDetailResponse {
  final int status;
  final String message;
  final int jumlah;
  final TahfidzDetailData data;

  TahfidzDetailResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory TahfidzDetailResponse.fromJson(Map<String, dynamic> json) {
    return TahfidzDetailResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      data: TahfidzDetailData.fromJson(json['data']),
    );
  }
}
