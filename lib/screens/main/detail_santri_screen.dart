import 'package:flutter/material.dart';
import '../../models/santri_model.dart';
import '../../services/santri_service.dart';

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

  final List<Tab> _tabs = const [
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
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final profil = _detail!.dataDiri;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Santri'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: Column(
        children: [
          // Card Profil
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: (profil.photo != null && profil.photo!.isNotEmpty)
                    ? NetworkImage('https://manajemen.ppatq-rf.id/assets/img/upload/photo/${profil.photo}')
                    : null,
                child: (profil.photo == null || profil.photo!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(profil.nama),
              subtitle: Text('No Induk: ${profil.noInduk} | Kelas: ${profil.kelas ?? "-"}'),
            ),
          ),
          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
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

    Widget _buildKesehatanTab(SantriDetail data) {
      if (data.riwayatSakit.isEmpty) {
        return const Center(child: Text('Belum ada data riwayat sakit'));
      }

      return ListView(
        children: data.riwayatSakit.map((e) {
          return ListTile(
            title: Text(e.keluhan),
            subtitle: Text('Sakit: ${e.tanggalSakit}, Sembuh: ${e.tanggalSembuh}'),
          );
        }).toList(),
      );
    }

    Widget _buildPemeriksaanTab(SantriDetail data) {
      if (data.pemeriksaan.isEmpty) {
        return const Center(child: Text('Belum ada data pemeriksaan'));
      }

      return ListView(
        children: data.pemeriksaan.map((e) {
          return ListTile(
            title: Text('Tinggi: ${e.tinggiBadan} cm'),
            subtitle: Text('Gigi: ${e.kondisiGigi}'),
          );
        }).toList(),
      );
    }

    Widget _buildRawatInapTab(SantriDetail data) {
      if (data.rawatInap.isEmpty) {
        return const Center(child: Text('Belum ada data rawat inap'));
      }

      return ListView(
        children: data.rawatInap.map((e) {
          return ListTile(
            title: Text(e.keluhan),
            subtitle: Text('Masuk: ${e.tanggalMasuk}, Keluar: ${e.tanggalKeluar ?? "-"}'),
          );
        }).toList(),
      );
    }

    Widget _buildPerilakuTab(SantriDetail data) {
      if (data.perilaku.isEmpty) {
        return const Center(child: Text('Belum ada data perilaku'));
      }

      return ListView(
        children: data.perilaku.map((e) {
          return ListTile(
            title: Text('Tanggal: ${e.tanggal}'),
            subtitle: Text('Kesopanan: ${e.kesopanan}, Kedisiplinan: ${e.kedisiplinan}'),
          );
        }).toList(),
      );
    }

    Widget _buildKelengkapanTab(SantriDetail data) {
      if (data.kelengkapan.isEmpty) {
        return const Center(child: Text('Belum ada data kelengkapan'));
      }

      return ListView(
        children: data.kelengkapan.map((e) {
          return ListTile(
            title: Text('Tanggal: ${e.tanggal}'),
            subtitle: Text('Sekolah: ${e.peralatanSekolah}, Diri: ${e.perlengkapanDiri}'),
          );
        }).toList(),
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
        itemCount: nilaiList.length,
        itemBuilder: (context, index) {
          final e = nilaiList[index];
          return ListTile(
            title: Text('Juz: ${e.nmJuz}'),
            subtitle: Text('Tanggal: ${e.tanggal}, Hafalan: ${e.hafalan}'),
          );
        },
      );
    }

    Widget _buildPembayaranTab(SantriDetail data) {
      if (data.riwayatBayar.isEmpty) {
        return const Center(child: Text('Belum ada data pembayaran'));
      }

      return ListView(
        children: data.riwayatBayar.map((e) {
          return ListTile(
            title: Text('Periode: ${e.periode}'),
            subtitle: Text('Validasi: ${e.validasi}'),
          );
        }).toList(),
      );
    }
  }
