import 'dart:io';

class DawuhAbah {
  final int id;
  final String judul;
  final String foto;
  final String isiDakwah;

  DawuhAbah({
    required this.id,
    required this.judul,
    required this.foto,
    required this.isiDakwah,
  });

  factory DawuhAbah.fromJson(Map<String, dynamic> json) {
    return DawuhAbah(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      judul: (json['judul'] ?? '').toString(),
      foto: (json['foto'] ?? '').toString(),
      isiDakwah: (json['isiDakwah'] ?? '').toString(),
    );
  }
}

class DawuhResponse {
  final int status;
  final String message;
  final List<DawuhAbah> data;

  DawuhResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DawuhResponse.fromJson(Map<String, dynamic> json) {
    return DawuhResponse(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => DawuhAbah.fromJson(item))
          .toList(),
    );
  }
}


class DawuhRequest {
  final String judul;
  final String isiDakwah;
  final File foto;

  DawuhRequest({
    required this.judul,
    required this.isiDakwah,
    required this.foto,
  });

  // Untuk debug
  @override
  String toString() {
    return 'DawuhRequest{judul: $judul, isiDakwah: $isiDakwah, foto: ${foto.path}}';
  }
}

class DawuhCreateResponse {
  final int status;
  final String message;
  final DawuhCreatedData? data;

  DawuhCreateResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DawuhCreateResponse.fromJson(Map<String, dynamic> json) {
    return DawuhCreateResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? DawuhCreatedData.fromJson(json['data']) : null,
    );
  }
}

class DawuhCreatedData {
  final String judul;
  final String foto;
  final String isiDakwah;
  final String slug;

  DawuhCreatedData({
    required this.judul,
    required this.foto,
    required this.isiDakwah,
    required this.slug,
  });

  factory DawuhCreatedData.fromJson(Map<String, dynamic> json) {
    return DawuhCreatedData(
      judul: json['judul'] ?? '',
      foto: json['foto'] ?? '',
      isiDakwah: json['isi_dakwah'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
