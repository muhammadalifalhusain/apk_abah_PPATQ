import 'package:flutter/material.dart';
import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';
import 'detail_keuangan_screen.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_syahriah_screen.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({super.key});

  @override
  State<KeuanganScreen> createState() => _KeuanganScreenState();
}

class _KeuanganScreenState extends State<KeuanganScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final KelasService _kelasService = KelasService();

  bool isLoading = true;
  List<Kelas> _kelasList = [];

  final KeuanganService _keuanganService = KeuanganService();
  KeuanganSyahriahData? _syahriahData;
  bool isLoadingSyahriah = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchKelas();
    _fetchSyahriah();
  }

  Future<void> _fetchSyahriah() async {
    final data = await _keuanganService.fetchSyahriahList();
    setState(() {
      _syahriahData = data;
      isLoadingSyahriah = false;
    });
  }


  Future<void> _fetchKelas() async {
    final data = await _kelasService.fetchKelasList();
    setState(() {
      _kelasList = data;
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
          'Uang Saku Santri',
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
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'Keuangan'),
            Tab(text: 'Syahriah'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKelasTab(),
          _buildSyahriahTab(),
        ],
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

  Widget _buildKelasTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kelasList.isEmpty) {
      return const Center(child: Text('Belum ada data Keuangan.'));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: _kelasList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final kelas = _kelasList[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KeuanganDetailScreen(kodeKelas: kelas.kode),
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

}
