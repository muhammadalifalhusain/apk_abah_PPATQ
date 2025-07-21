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
          indicatorColor: Color.fromARGB(255, 56, 96, 31),
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
                  _buildRow('Kelas', profil.kelas ?? '-'),
                  _buildRow('Kamar', profil.namaMurroby ?? '-'),
                  _buildRow('Tahfidz', profil.namaTahfidz ?? '-'),
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
              '$label',
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data pemeriksaan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat pemeriksaan kesehatan akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.pemeriksaan.length,
      itemBuilder: (context, index) {
        final e = data.pemeriksaan[index];
        final isExpanded = index == 0 && data.pemeriksaan.length > 1;
        bool isCardExpanded = isExpanded;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 96, 31),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pemeriksaan ke-${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (data.pemeriksaan.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.pemeriksaan.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, 'Tanggal', e.tanggalPemeriksaan ?? '-'),
                            _buildDataItem(Icons.height, 'Tinggi Badan', '${e.tinggiBadan} cm'),
                            _buildDataItem(Icons.monitor_weight, 'Berat Badan', '${e.beratBadan} kg'),
                            _buildDataItem(Icons.straighten, 'Lingkar Pinggul', '${e.lingkarPinggul} cm'),
                            _buildDataItem(Icons.straighten, 'Lingkar Dada', '${e.lingkarDada} cm'),
                            _buildDataItem(Icons.health_and_safety, 'Kondisi Gigi', e.kondisiGigi),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildDataItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '$label',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    value.isNotEmpty ? value : "-",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawatInapTab(SantriDetail data) {
    if (data.rawatInap.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data rawat inap',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat rawat inap akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.rawatInap.length,
      itemBuilder: (context, index) {
        final e = data.rawatInap[index];
        final isExpanded = index == 0 && data.rawatInap.length > 1;
        bool isCardExpanded = isExpanded;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 96, 31), 
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_hospital,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.keluhan,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (data.rawatInap.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.rawatInap.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, 'Masuk', e.tanggalMasuk ?? '-'),
                            _buildDataItem(Icons.calendar_today_outlined, 'Keluhan', e.keluhan ?? "-"),
                            _buildDataItem(Icons.calendar_today_outlined, 'Terapi', e.terapi ?? "-"),
                            _buildDataItem(Icons.calendar_today_outlined, 'Keluar', e.tanggalKeluar ?? "-"),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data ketahfidzan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat hafalan akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final tahunKeys = data.ketahfidzan.keys.toList();
    final tahun = tahunKeys.first;

    final bulanKeys = data.ketahfidzan[tahun]!.keys.toList();
    if (bulanKeys.isEmpty) {
      return Center(
        child: Text(
          "Belum ada data bulan ketahfidzan",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final bulan = bulanKeys.first;
    final nilaiList = data.ketahfidzan[tahun]![bulan]!;

    if (nilaiList.isEmpty) {
      return Center(
        child: Text(
          "Belum ada nilai ketahfidzan",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nilaiList.length,
      itemBuilder: (context, index) {
        final e = nilaiList[index];
        final isExpanded = index == 0 && nilaiList.length > 1;
        bool isCardExpanded = isExpanded;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 96, 31),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.book,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Setoran ${e.nmJuz}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (nilaiList.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || nilaiList.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, "Tanggal", e.tanggal),
                            _buildDataItem(Icons.bookmark, "Nama Juz", e.nmJuz),
                            _buildDataItem(Icons.format_quote, "Hafalan", e.hafalan),
                            _buildDataItem(Icons.mic, "Tilawah", e.tilawah),
                            _buildDataItem(Icons.auto_awesome, "Kefasihan", e.kefasihan),
                            _buildDataItem(Icons.memory, "Daya Ingat", e.dayaIngat),
                            _buildDataItem(Icons.speed, "Kelancaran", e.kelancaran),
                            _buildDataItem(Icons.graphic_eq, "Tajwid", e.praktekTajwid),
                            _buildDataItem(Icons.record_voice_over, "Makhroj", e.makhroj),
                            _buildDataItem(Icons.compare, "Tanafus", e.tanafus),
                            _buildDataItem(Icons.pause, "Waqof Wasol", e.waqofWasol),
                            _buildDataItem(Icons.warning, "Ghorib", e.ghorib),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPembayaranTab(SantriDetail data) {
    if (data.riwayatBayar.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat pembayaran akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.riwayatBayar.length,
      itemBuilder: (context, index) {
        final e = data.riwayatBayar[index];
        final isExpanded = index == 0 && data.riwayatBayar.length > 1;
        bool isCardExpanded = isExpanded;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 96, 31), 
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Periode ${e.periode}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                e.validasi,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (data.riwayatBayar.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.riwayatBayar.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tanggal Bayar: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  e.tanggalBayar,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Rincian Pembayaran',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: e.jenisPembayaran.entries.map((entry) {
                                  final isLast = entry == e.jenisPembayaran.entries.last;
                                  
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: isLast ? null : Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.key,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Rp ${entry.value},00',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}