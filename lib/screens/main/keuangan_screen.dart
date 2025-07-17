import 'package:flutter/material.dart';
import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';

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
        title: const Text('Keuangan Santri'),
        bottom: TabBar(
          controller: _tabController,
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
            title: Text(kelas.namaKelas),
            subtitle: Text('Wali Kelas: ${kelas.guru}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              // Arahkan ke detail keuangan kelas atau santri
              // Navigator.push(context, MaterialPageRoute(builder: (_) => KelasDetailScreen(kelas: kelas)));
            },
          ),
        );
      },
    );
  }
}
