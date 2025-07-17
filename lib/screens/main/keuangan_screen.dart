import 'package:flutter/material.dart';
import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';
import 'keuangan_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchKelas();
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
          'Keuangan Santri',
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
          const Center(child: Text('Halaman Syahriah')),
        ],
      ),
    );
  }

  Widget _buildKelasTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kelasList.isEmpty) {
      return const Center(child: Text('Belum ada data kelas.'));
    }
    return ListView.builder(
      itemCount: _kelasList.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final kelas = _kelasList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              '${kelas.namaKelas} - ${kelas.guru}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KeuanganDetailScreen(kodeKelas: kelas.kode),
                ),
              );
            },
          ),
        );
      },
    );
  }

}
