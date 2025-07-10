import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/aset_model.dart';
import '../../services/aset_service.dart';

class AsetScreen extends StatefulWidget {
  const AsetScreen({super.key});

  @override
  State<AsetScreen> createState() => _AsetScreenState();
}

class _AsetScreenState extends State<AsetScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<AsetResponse> _asetFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _asetFuture = AsetService().fetchAsetData();
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: Colors.indigo, 
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Ruang'),
            Tab(text: 'Barang'),
            Tab(text: 'Tanah'),
          ],
        ),
      ),
    );
  }


  Widget _buildAsetRuangList(List<AsetRuang> ruangList) {
    if (ruangList.isEmpty) {
      return const Center(child: Text('Tidak ada data ruang'));
    }

    return ListView.separated(
      itemCount: ruangList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = ruangList[index];
        return ListTile(
          title: Text(item.nama, style: GoogleFonts.poppins()),
          subtitle: Text(
            'Gedung: ${item.gedung} | Lantai: ${item.lantai} | Jenis: ${item.jenisRuang}',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        );
      },
    );
  }

  Widget _buildAsetBarangList(List<AsetBarang> barangList) {
    if (barangList.isEmpty) {
      return const Center(child: Text('Tidak ada data barang'));
    }

    return ListView.separated(
      itemCount: barangList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = barangList[index];
        return ListTile(
          title: Text(item.nama, style: GoogleFonts.poppins()),
          subtitle: Text(
            'Ruang: ${item.ruang} | Jenis: ${item.jenisBarang} | Status: ${item.statusBarang}',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        );
      },
    );
  }

  Widget _buildAsetTanahList(List<AsetTanah> tanahList) {
    if (tanahList.isEmpty) {
      return const Center(child: Text('Tidak ada data tanah'));
    }

    return ListView.separated(
      itemCount: tanahList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = tanahList[index];
        return ListTile(
          title: Text(item.nama, style: GoogleFonts.poppins()),
          subtitle: Text(
            'Alamat: ${item.alamat}\nLuas: ${item.luas} m²\nSertifikat: ${item.noSertifikat}\nStatus: ${item.statusTanah}',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          isThreeLine: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Aset',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: _buildTabBar(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<AsetResponse>(
        future: _asetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final data = snapshot.data!;
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAsetRuangList(data.asetRuang),
              _buildAsetBarangList(data.asetBarang),
              _buildAsetTanahList(data.asetTanah),
            ],
          );
        },
      ),
    );
  }
}
