class PegawaiData {
  final int id;
  final String photo;
  final String nama;
  final String jenisKelamin;

  PegawaiData({
    required this.id,
    required this.photo,
    required this.nama,
    required this.jenisKelamin,
  });

  factory PegawaiData.fromJson(Map<String, dynamic> json) {
    return PegawaiData(
      id: json['id'] ?? 0,
      photo: (json['photo'] ?? '').toString().isNotEmpty
          ? json['photo']
          : 'default.png',
      nama: (json['nama'] ?? 'Tidak diketahui').toString(),
      jenisKelamin: (json['jenisKelamin'] ?? 'Tidak diketahui').toString(),
    );
  }
}

class PegawaiPaginatedData {
  final int currentPage;
  final List<PegawaiData> data;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;
  final int lastPage;

  PegawaiPaginatedData({
    required this.currentPage,
    required this.data,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.total,
    required this.lastPage,
  });

  factory PegawaiPaginatedData.fromJson(Map<String, dynamic> json) {
    return PegawaiPaginatedData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List).map((e) => PegawaiData.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }

  factory PegawaiPaginatedData.empty() {
    return PegawaiPaginatedData(
      currentPage: 1,
      data: [],
      nextPageUrl: null,
      prevPageUrl: null,
      total: 0,
      lastPage: 1,
    );
  }
}

class PegawaiResponse {
  final int status;
  final String message;
  final PegawaiPaginatedData data;

  PegawaiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PegawaiResponse.fromJson(Map<String, dynamic> json) {
    return PegawaiResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: PegawaiPaginatedData.fromJson(json['data']),
    );
  }
}

class PegawaiDetailDataDiri {
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String jenisKelamin;
  final String idJabatan;
  final String namaJabatan;
  final String alhafidz;
  final String alamat;
  final String pendidikan;
  final String pengangkatan;
  final String lembagaInduk;
  final String photo;

  PegawaiDetailDataDiri({
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.idJabatan,
    required this.namaJabatan,
    required this.alhafidz,
    required this.alamat,
    required this.pendidikan,
    required this.pengangkatan,
    required this.lembagaInduk,
    required this.photo,
  });

  factory PegawaiDetailDataDiri.fromJson(Map<String, dynamic> json) {
    print('Parsing dataDiri: $json');

    return PegawaiDetailDataDiri(
      nama: json['nama']?.toString() ?? 'Tidak diketahui',
      tempatLahir: json['tempatLahir']?.toString() ?? '-',
      tanggalLahir: json['tanggalLahir']?.toString() ?? '-',
      jenisKelamin: json['jenisKelamin']?.toString() ?? '-',
      idJabatan: json['idJabatan']?.toString() ?? '',
      namaJabatan: json['namaJabatan']?.toString() ?? '-',
      alhafidz: json['alhafidz']?.toString() ?? '-',
      alamat: json['alamat']?.toString() ?? '-',
      pendidikan: json['pendidikan']?.toString() ?? '-',
      pengangkatan: json['pengangkatan']?.toString() ?? '-',
      lembagaInduk: json['lembagaInduk']?.toString() ?? '-',
      photo: (json['photo']?.toString().isNotEmpty ?? false)
          ? json['photo']
          : 'default.png',
    );
  }
}

class KetahfidzanSantri {
  final int noInduk;
  final String nama;
  final String photo;
  final String kelas;
  final String jenisKelamin;

  KetahfidzanSantri({
    required this.noInduk,
    required this.nama,
    required this.photo,
    required this.kelas,
    required this.jenisKelamin,
  });

  factory KetahfidzanSantri.fromJson(Map<String, dynamic> json) {
    return KetahfidzanSantri(
      noInduk: json['noInduk'] ?? 0,
      nama: (json['nama'] ?? 'Tidak diketahui').toString(),
      photo: (json['photo'] ?? '').toString().isNotEmpty
          ? json['photo']
          : 'default.png',
      kelas: (json['kelas'] ?? '-').toString(),
      jenisKelamin: (json['jenisKelamin'] ?? '-').toString(),
    );
  }
}

class PegawaiDetail {
  final PegawaiDetailDataDiri dataDiri;
  final List<KetahfidzanSantri> ketahfidzan;

  PegawaiDetail({
    required this.dataDiri,
    required this.ketahfidzan,
  });

  factory PegawaiDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    print('PegawaiDetail.fromJson received: $data');

    final dataDiri = PegawaiDetailDataDiri.fromJson(data['dataDiri'] ?? {});
    final List<KetahfidzanSantri> ketahfidzanList = (data['ketahfidzan'] != null && data['ketahfidzan'] is List)
        ? (data['ketahfidzan'] as List).map((e) => KetahfidzanSantri.fromJson(e)).toList()
        : [];

    return PegawaiDetail(
      dataDiri: dataDiri,
      ketahfidzan: ketahfidzanList,
    );
  }
}



