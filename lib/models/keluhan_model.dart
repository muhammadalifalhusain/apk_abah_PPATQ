class KeluhanResponse {
  final int status;
  final String message;
  final Map<String, KategoriKeluhan> data;

  KeluhanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KeluhanResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, KategoriKeluhan> kategoriMap = {};
    if (json['data'] != null && json['data'] is Map) {
      (json['data'] as Map).forEach((key, value) {
        kategoriMap[key.toString().trim()] = KategoriKeluhan.fromJson(value);
      });
    }

    return KeluhanResponse(
      status: json['status'] ?? 0,
      message: json['message']?.toString() ?? 'Terjadi kesalahan.',
      data: kategoriMap,
    );
  }
}

class KategoriKeluhan {
  final List<KeluhanItem> data;

  KategoriKeluhan({required this.data});

  factory KategoriKeluhan.fromJson(Map<String, dynamic> json) {
    return KategoriKeluhan(
      data: (json['data'] as List? ?? [])
          .map((item) => KeluhanItem.fromJson(item))
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
  final String jenis;
  final String status;
  final int idKategori;
  final String masukan;
  final String saran;
  final int rating;
  final String balasan;
  final String tanggal;

  KeluhanItem({
    required this.idKeluhan,
    this.idBalasan,
    required this.namaPelapor,
    required this.email,
    required this.noHp,
    required this.namaSantri,
    required this.namaWaliSantri,
    required this.jenis,
    required this.status,
    required this.idKategori,
    required this.masukan,
    required this.saran,
    required this.rating,
    required this.balasan,
    required this.tanggal,
  });

  factory KeluhanItem.fromJson(Map<String, dynamic> json) {
    return KeluhanItem(
      idKeluhan: json['idKeluhan'] ?? 0,
      idBalasan: json['idBalasan'],
      namaPelapor: json['namaPelapor']?.toString() ?? '-',
      email: json['email']?.toString() ?? '',
      noHp: json['noHp']?.toString() ?? '',
      namaSantri: json['namaSantri']?.toString() ?? '-',
      namaWaliSantri: json['namaWaliSantri']?.toString() ?? '-',
      jenis: json['jenis']?.toString() ?? 'Keluhan',
      status: json['status']?.toString() ?? 'Belum Ditangani',
      idKategori: json['idKategori'] ?? 0,
      masukan: json['masukan']?.toString() ?? '',
      saran: json['saran']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      balasan: json['balasan']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
    );
  }

  KeluhanItem copyWith({
    int? idKeluhan,
    int? idBalasan,
    String? namaPelapor,
    String? email,
    String? noHp,
    String? namaSantri,
    String? namaWaliSantri,
    String? jenis,
    String? status,
    int? idKategori,
    String? masukan,
    String? saran,
    int? rating,
    String? balasan,
    String? tanggal,
  }) {
    return KeluhanItem(
      idKeluhan: idKeluhan ?? this.idKeluhan,
      idBalasan: idBalasan ?? this.idBalasan,
      namaPelapor: namaPelapor ?? this.namaPelapor,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      namaSantri: namaSantri ?? this.namaSantri,
      namaWaliSantri: namaWaliSantri ?? this.namaWaliSantri,
      jenis: jenis ?? this.jenis,
      status: status ?? this.status,
      idKategori: idKategori ?? this.idKategori,
      masukan: masukan ?? this.masukan,
      saran: saran ?? this.saran,
      rating: rating ?? this.rating,
      balasan: balasan ?? this.balasan,
      tanggal: balasan ?? this.tanggal,
    );
  }
}

extension KeluhanItemExtension on KeluhanItem {
  int get statusCode {
    if (status == '1') return 1;
    if (status == '2') return 2;
    if (status.toLowerCase().contains('belum')) return 1;
    if (status.toLowerCase().contains('ditangani')) return 2;

    return 0;
  }

  String get statusLabel {
    if (statusCode == 1) return "Belum Ditangani";
    if (statusCode == 2) return "Sudah Ditangani";
    return status;
  }

  int get statusColorValue {
    if (statusCode == 1) return 0xFFFFF3F3; 
    if (statusCode == 2) return 0xFFE9F7EF; 
    return 0xFFFFFFFF;
  }
}

class ReplyKeluhanRequest {
  final int idKeluhan;
  final String pesan;

  ReplyKeluhanRequest({
    required this.idKeluhan,
    required this.pesan,
  });

  Map<String, dynamic> toJson() {
    return {
      'idKeluhan': idKeluhan,
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
      message: json['message']?.toString() ?? '',
    );
  }
}
