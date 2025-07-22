import 'package:flutter/material.dart';
import '../../models/kamar_model.dart';
import '../../services/kamar_service.dart';
import 'detail_keuangan_screen.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart';
import '../../models/lapor_bayar_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_syahriah_screen.dart';
import 'detail_lapor_bayar_screen.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({super.key});

  @override
  State<KeuanganScreen> createState() => _KeuanganScreenState();
}

class _KeuanganScreenState extends State<KeuanganScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final KamarService _kamarService = KamarService();

  bool isLoading = true;
  List<Kamar> _kamarList = [];

  final KeuanganService _keuanganService = KeuanganService();
  KeuanganSyahriahData? _syahriahData;
  bool isLoadingSyahriah = true;
  PembayaranResponse? _laporBayarData;
  bool isLoadingLaporBayar = true;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchKamar();
    _fetchLaporBayar();
    _fetchSyahriah();
  }

  Future<void> _fetchLaporBayar() async {
    final data = await _keuanganService.fetchLaporBayar();
    setState(() {
      _laporBayarData = data;
      isLoadingLaporBayar = false;
    });
  }


  Future<void> _fetchSyahriah() async {
    final data = await _keuanganService.fetchSyahriahList();
    setState(() {
      _syahriahData = data;
      isLoadingSyahriah = false;
    });
  }


  Future<void> _fetchKamar() async {
    final response = await _kamarService.fetchKamarData();
    setState(() {
      _kamarList = response?.data ?? [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keuangan',
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
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70, 
          indicatorColor: Colors.black,
          indicatorWeight: 3.0, 
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Saku'),
            Tab(text: 'Lapor Bayar'),
            Tab(text: 'Syahriah'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKamarTab(),
          _buildLaporBayarTab(),
          _buildSyahriahTab(),
        ],
      ),
    );
  }

  Widget _buildLaporBayarTab() {
    if (isLoadingLaporBayar) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_laporBayarData == null || _laporBayarData!.data.isEmpty) {
      return const Center(child: Text('Tidak ada data lapor bayar.'));
    }

    final dataKelas = _laporBayarData!.data.entries.toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: dataKelas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final entry = dataKelas[index];
          final kodeKelas = entry.key;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailLaporBayarScreen(kodeKelas: kodeKelas),
                ),
              );
            },
            child: Card(
              color: const Color.fromARGB(255, 56, 96, 31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    'Kelas $kodeKelas',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildSyahriahTab() {
    if (isLoadingSyahriah) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_syahriahData == null || _syahriahData!.dataKelas.isEmpty) {
      return const Center(child: Text('Tidak ada data Syahriah.'));
    }

    final dataKelas = _syahriahData!.dataKelas;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: dataKelas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final kelas = dataKelas[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailSyahriahScreen(kodeKelas: kelas.kode),
                ),
              );
            },
            child: Card(
              color: const Color.fromARGB(255, 56, 96, 31), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    kelas.namaKelas,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKamarTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kamarList.isEmpty) {
      return const Center(child: Text('Belum ada data kamar.'));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: _kamarList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final kamar = _kamarList[index];
          final imageUrl = (kamar.fotoMurroby != null && kamar.fotoMurroby!.isNotEmpty)
              ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${kamar.fotoMurroby}'
              : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(kamar.murroby)}&background=0D8ABC&color=fff';

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KeuanganDetailScreen(idKamar: kamar.id.toString()),
                ),
              );
            },
            child: Card(
              color: const Color.fromARGB(255, 56, 96, 31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      kamar.murroby,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
