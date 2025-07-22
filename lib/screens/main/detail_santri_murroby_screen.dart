import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/santri_model.dart';
import '../../services/santri_service.dart';
import '../../models/kamar_model.dart';
import '../../services/kamar_service.dart';
import '../../utils/phone_formatter.dart';
import '../../utils/currency_formatter.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailSantriMurrobyScreen extends StatefulWidget {
  final int noInduk;

  const DetailSantriMurrobyScreen({required this.noInduk, Key? key}) : super(key: key);

  @override
  State<DetailSantriMurrobyScreen> createState() => _DetailSantriMurrobyScreenState();
}

class _DetailSantriMurrobyScreenState extends State<DetailSantriMurrobyScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  bool _showMasuk = false;
  bool _showKeluar = false;

  SantriDetail? _detail;
  SakuResponse? _sakuData;

  bool _showOrangTua = false;


  final List<Tab> _tabs = const [
    Tab(text: 'Profil'),
    Tab(text: 'Uang Saku'),
    Tab(text: 'Kesehatan'),
    Tab(text: 'Pemeriksaan'),
    Tab(text: 'Rawat Inap'),
    Tab(text: 'Kelengkapan'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await SantriService().fetchSantriDetail(widget.noInduk);
    final saku = await KamarService().fetchSakuData(widget.noInduk.toString());

    setState(() {
      _detail = data;
      _sakuData = saku;
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
          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfilTab(_detail!),
                _buildSakuTab(),
                _buildKesehatanTab(_detail!),
                _buildPemeriksaanTab(_detail!),
                _buildRawatInapTab(_detail!),
                _buildKelengkapanTab(_detail!),
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

  Widget _buildSakuTab() {
    if (_sakuData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada data saku', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    final validMasuk = _sakuData!.data.uangMasuk.where((e) =>
        e.jumlahMasuk != null &&
        e.jumlahMasuk != '-' &&
        e.jumlahMasuk.toString() != '0' &&
        e.tanggalTransaksi != null &&
        e.tanggalTransaksi != '-').toList();

    final validKeluar = _sakuData!.data.uangKeluar.where((e) =>
        e.jumlahKeluar != null &&
        e.jumlahKeluar != '-' &&
        e.tanggalTransaksi != null &&
        e.tanggalTransaksi != '-' &&
        e.namaMurroby != null &&
        e.namaMurroby != '-').toList();

    String formatDate(String? date) {
      if (date == null || date == '-' || date.isEmpty) return 'Tanggal tidak tersedia';
      try {
        DateTime parsedDate = DateTime.parse(date);
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
      } catch (e) {
        return date;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saldo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 56, 96, 31),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo Saat Ini', style: TextStyle(fontSize: 14, color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(_sakuData!.data.saldo),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            initiallyExpanded: false,
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text('Riwayat Saku Masuk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            children: [
              if (validMasuk.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('Belum ada data Saku masuk', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                )
              else
                ...validMasuk.map((item) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          formatDate(item.tanggalTransaksi),
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              CurrencyFormatter.format(int.parse(item.jumlahMasuk.toString())),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                              item.uangAsal ?? 'Tidak ada keterangan',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 8),
          ],
        ),

        const SizedBox(height: 12),

        // Expansion untuk Riwayat Saku Keluar
        ExpansionTile(
          initiallyExpanded: false,
          leading: const Icon(Icons.trending_down, color: Colors.red),
          title: const Text('Riwayat Saku Keluar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          children: [
            if (validKeluar.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text('Belum ada data uang keluar', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              )
            else
              ...validKeluar.map((item) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.remove, color: Colors.red, size: 20),
                      ),
                      title: Text(
                        CurrencyFormatter.format(int.parse(item.jumlahKeluar.toString())),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(formatDate(item.tanggalTransaksi), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text('Oleh: ${item.namaMurroby}', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 8),
          ],
        ),

        const SizedBox(height: 16),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.healing_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data riwayat sakit',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat sakit santri akan muncul di sini',
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
      itemCount: data.riwayatSakit.length,
      itemBuilder: (context, index) {
        final e = data.riwayatSakit[index];
        bool isCardExpanded = index == 0 && data.riwayatSakit.length > 1;

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
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 56, 96, 31),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.healing, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Riwayat Sakit ke-${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (data.riwayatSakit.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.riwayatSakit.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.sick, 'Keluhan', e.keluhan),
                            _buildDataItem(Icons.event, 'Tanggal Sakit', e.tanggalSakit ?? '-'),
                            _buildDataItem(Icons.attractions, 'Tindakan', e.tindakan ?? '-'),
                            _buildDataItem(Icons.check_circle, 'Tanggal Sembuh', e.tanggalSembuh ?? '-'),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.backpack_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data kelengkapan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat kelengkapan santri akan muncul di sini',
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
      itemCount: data.kelengkapan.length,
      itemBuilder: (context, index) {
        final e = data.kelengkapan[index];
        final isExpanded = index == 0 && data.kelengkapan.length > 1;
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
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 56, 96, 31),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.backpack, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Kelengkapan ke-${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (data.kelengkapan.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.kelengkapan.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, 'Tanggal', e.tanggal),
                            _buildDataItem(Icons.shower, 'Perlengkapan Mandi', e.perlengkapanMandi),
                            _buildDataItem(Icons.shower, 'Catatan', e.catatanMandi),
                            _buildDataItem(Icons.school, 'Peralatan Sekolah', e.peralatanSekolah),
                            _buildDataItem(Icons.school, 'Catatan', e.catatanSekolah),
                            _buildDataItem(Icons.checkroom, 'Perlengkapan', e.perlengkapanDiri),
                            _buildDataItem(Icons.checkroom, 'Catatan', e.catatanDiri),
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