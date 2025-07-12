class KeluhanResponse {
  final int status;
  final String message;
  final KeluhanData data;

  KeluhanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KeluhanResponse.fromJson(Map<String, dynamic> json) {
    return KeluhanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: KeluhanData.fromJson(json['data'] ?? {}),
    );
  }
}

class KeluhanData {
  final List<KeluhanItem> belumDitangani;
  final List<KeluhanItem> ditangani;

  KeluhanData({
    required this.belumDitangani,
    required this.ditangani,
  });

  factory KeluhanData.fromJson(Map<String, dynamic> json) {
    return KeluhanData(
      belumDitangani: (json['Belum Ditangani'] as List<dynamic>? ?? [])
          .map((e) => KeluhanItem.fromJson(e))
          .toList(),
      ditangani: (json['Ditangani'] as List<dynamic>? ?? [])
          .map((e) => KeluhanItem.fromJson(e))
          .toList(),
    );
  }
}



class KeluhanItem {
  final int idKeluhan;
  final int? idBalasan;
  final String namaPelapor;
  final String email;
  final String noHp;
  final String namaSantri;
  final String namaWaliSantri;
  final String kategori;
  final String jenis;
  final int status; // Digunakan secara internal sebagai int
  final String masukan;
  final String saran;
  final int rating;
  final String balasan;

  KeluhanItem({
    required this.idKeluhan,
    this.idBalasan,
    required this.namaPelapor,
    required this.email,
    required this.noHp,
    required this.namaSantri,
    required this.namaWaliSantri,
    required this.kategori,
    required this.jenis,
    required this.status,
    required this.masukan,
    required this.saran,
    required this.rating,
    required this.balasan,
  });

  factory KeluhanItem.fromJson(Map<String, dynamic> json) {
    return KeluhanItem(
      idKeluhan: json['idKeluhan'] ?? 0,
      idBalasan: json['idBalasan'],
      namaPelapor: (json['namaPelapor'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      noHp: (json['noHp'] ?? '').toString(),
      namaSantri: (json['namaSantri'] ?? '').toString(),
      namaWaliSantri: (json['namaWaliSantri'] ?? '').toString(),
      kategori: (json['kategori'] ?? '').toString(),
      jenis: (json['jenis'] ?? '').toString(),
      status: _statusStringToInt(json['status']),
      masukan: (json['masukan'] ?? '').toString(),
      saran: (json['saran'] ?? '').toString(),
      rating: json['rating'] ?? 0,
      balasan: (json['balasan'] ?? '').toString(),
    );
  }

  KeluhanItem copyWith({
    int? status,
    String? balasan,
  }) {
    return KeluhanItem(
      idKeluhan: idKeluhan,
      idBalasan: idBalasan,
      namaPelapor: namaPelapor,
      email: email,
      noHp: noHp,
      namaSantri: namaSantri,
      namaWaliSantri: namaWaliSantri,
      kategori: kategori,
      jenis: jenis,
      status: status ?? this.status,
      masukan: masukan,
      saran: saran,
      rating: rating,
      balasan: balasan ?? this.balasan,
    );
  }

  /// Label status untuk ditampilkan ke UI
  String get statusLabel {
    switch (status) {
      case 1:
        return 'Belum Ditangani';
      case 2:
        return 'Sudah Ditangani';
      default:
        return 'Tidak Diketahui';
    }
  }
  int get statusColorValue {
    switch (status) {
      case 1:
        return 0xFFFFE5E5; // merah muda
      case 2:
        return 0xFFE6FFEA; // hijau muda
      default:
        return 0xFFFFFFFF; // putih
    }
  }

  /// Fungsi bantu untuk parse dari string status ke int
  static int _statusStringToInt(dynamic value) {
    final statusString = value?.toString().toLowerCase();
    switch (statusString) {
      case 'ditangani':
        return 2;
      case 'belum ditangani':
        return 1;
      default:
        return 0;
    }
  }
}

class ReplyKeluhanRequest {
  final int idKeluhan;
  final int status;
  final String pesan;

  ReplyKeluhanRequest({
    required this.idKeluhan,
    required this.status,
    required this.pesan,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'pesan': pesan,
    };
  }
}


class ReplyKeluhanResponse {
  final int status;
  final String message;

  ReplyKeluhanResponse({
    required this.status,
    required this.message,
  });

  factory ReplyKeluhanResponse.fromJson(Map<String, dynamic> json) {
    return ReplyKeluhanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

