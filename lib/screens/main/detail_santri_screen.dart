import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/santri_model.dart';
import '../../services/santri_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/phone_formatter.dart';
class SantriDetailScreen extends StatefulWidget {
  final int noInduk;

  const SantriDetailScreen({required this.noInduk, Key? key}) : super(key: key);

  @override
  State<SantriDetailScreen> createState() => _SantriDetailScreenState();
}

class _SantriDetailScreenState extends State<SantriDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  SantriDetail? _detail;
  bool _showOrangTua = false;

  final List<Tab> _tabs = const [
    Tab(text: 'Profil'),
    Tab(text: 'Kesehatan'),
    Tab(text: 'Pemeriksaan'),
    Tab(text: 'Rawat Inap'),
    Tab(text: 'Perilaku'),
    Tab(text: 'Kelengkapan'),
    Tab(text: 'Ketahfidzan'),
    Tab(text: 'Pembayaran'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await SantriService().fetchSantriDetail(widget.noInduk);
    setState(() {
      _detail = data;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final profil = _detail!.dataDiri;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Santri',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          tabAlignment: TabAlignment.start,
          tabs: _tabs,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: (profil.photo != null && profil.photo!.isNotEmpty)
                          ? NetworkImage('https://manajemen.ppatq-rf.id/assets/img/upload/photo/${profil.photo}')
                          : null,
                      child: (profil.photo == null || profil.photo!.isEmpty)
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profil.nama,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No Induk: ${profil.noInduk}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Kelas: ${profil.kelas ?? "-"}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Kota: ${profil.kotaKab ?? "-"}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfilTab(_detail!),
                _buildKesehatanTab(_detail!),
                _buildPemeriksaanTab(_detail!),
                _buildRawatInapTab(_detail!),
                _buildPerilakuTab(_detail!),
                _buildKelengkapanTab(_detail!),
                _buildKetahfidzanTab(_detail!),
                _buildPembayaranTab(_detail!),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfilTab(SantriDetail data) {
    final profil = data.dataDiri;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final rawNoHp = profil.noHp ?? '';
              final noHp = formatPhoneToInternational(rawNoHp);
              if (noHp.isNotEmpty) {
                final Uri url = Uri.parse('https://wa.me/$noHp');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal membuka WhatsApp')),
                  );
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "Hubungi Wali Santri",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            "Data Diri Santri",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Tanggal Lahir', profil.tanggalLahirFormatted ?? '-'),
                  _buildRow('Jenis Kelamin', profil.jenisKelaminFormatted),
                  _buildRow('Alamat', profil.alamat ?? '-'),
                  _buildRow('Kota/Kabupaten', profil.kotaKab ?? '-'),
                  _buildRow('Kamar', profil.kamar ?? '-'),
                  _buildRow('Tahfidz', profil.kelasTahfidz ?? '-'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Data Orang Tua",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showOrangTua = !_showOrangTua;
              });
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _showOrangTua
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow('Nama Ayah', profil.namaAyah ?? '-'),
                          _buildRow('Pendidikan', profil.pendidikanAyah ?? '-'),
                          _buildRow('Pekerjaan', profil.pekerjaanAyah ?? '-'),
                          const Divider(),
                          _buildRow('Nama Ibu', profil.namaIbu ?? '-'),
                          _buildRow('Pendidikan', profil.pendidikanIbu ?? '-'),
                          _buildRow('Pekerjaan', profil.pekerjaanIbu ?? '-'),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Klik untuk lihat data orang tua',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildKesehatanTab(SantriDetail data) {
    if (data.riwayatSakit.isEmpty) {
      return const Center(child: Text('Belum ada data riwayat sakit'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.riwayatSakit.length,
      itemBuilder: (context, index) {
        final e = data.riwayatSakit[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              e.keluhan,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Sakit: ${e.tanggalSakit}\nSembuh: ${e.tanggalSembuh}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPemeriksaanTab(SantriDetail data) {
    if (data.pemeriksaan.isEmpty) {
      return const Center(child: Text('Belum ada data pemeriksaan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.pemeriksaan.length,
      itemBuilder: (context, index) {
        final e = data.pemeriksaan[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              'Tinggi: ${e.tinggiBadan} cm',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Gigi: ${e.kondisiGigi}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRawatInapTab(SantriDetail data) {
    if (data.rawatInap.isEmpty) {
      return const Center(child: Text('Belum ada data rawat inap'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.rawatInap.length,
      itemBuilder: (context, index) {
        final e = data.rawatInap[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              e.keluhan,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Masuk: ${e.tanggalMasuk}\nKeluar: ${e.tanggalKeluar ?? "-"}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPerilakuTab(SantriDetail data) {
    if (data.perilaku.isEmpty) {
      return const Center(child: Text('Belum ada data perilaku'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.perilaku.length,
      itemBuilder: (context, index) {
        final e = data.perilaku[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              'Tanggal: ${e.tanggal}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Kesopanan: ${e.kesopanan}\nKedisiplinan: ${e.kedisiplinan}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildKelengkapanTab(SantriDetail data) {
    if (data.kelengkapan.isEmpty) {
      return const Center(child: Text('Belum ada data kelengkapan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.kelengkapan.length,
      itemBuilder: (context, index) {
        final e = data.kelengkapan[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              'Tanggal: ${e.tanggal}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Sekolah: ${e.peralatanSekolah}\nDiri: ${e.perlengkapanDiri}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildKetahfidzanTab(SantriDetail data) {
    if (data.ketahfidzan.isEmpty) {
      return const Center(child: Text("Belum ada data ketahfidzan"));
    }

    final tahunKeys = data.ketahfidzan.keys.toList();
    final tahun = tahunKeys.first;

    final bulanKeys = data.ketahfidzan[tahun]!.keys.toList();
    if (bulanKeys.isEmpty) {
      return const Center(child: Text("Belum ada data bulan ketahfidzan"));
    }

    final bulan = bulanKeys.first;
    final nilaiList = data.ketahfidzan[tahun]![bulan]!;

    if (nilaiList.isEmpty) {
      return const Center(child: Text("Belum ada nilai ketahfidzan"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: nilaiList.length,
      itemBuilder: (context, index) {
        final e = nilaiList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              '${e.nmJuz}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Tanggal: ${e.tanggal}\nHafalan: ${e.hafalan}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPembayaranTab(SantriDetail data) {
    if (data.riwayatBayar.isEmpty) {
      return const Center(child: Text('Belum ada data pembayaran'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.riwayatBayar.length,
      itemBuilder: (context, index) {
        final e = data.riwayatBayar[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              'Periode: ${e.periode}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Validasi: ${e.validasi}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}