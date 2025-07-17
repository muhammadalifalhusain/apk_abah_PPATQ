import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart';

class DetailSyahriahScreen extends StatefulWidget {
  final String kodeKelas;

  const DetailSyahriahScreen({super.key, required this.kodeKelas});

  @override
  State<DetailSyahriahScreen> createState() => _DetailSyahriahScreenState();
}

class _DetailSyahriahScreenState extends State<DetailSyahriahScreen> {
  final KeuanganService _keuanganService = KeuanganService();
  LaporanSyahriahData? _data;
  bool isLoading = true;
  String? error;
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _sudahBayarKey = GlobalKey();
  final GlobalKey _belumBayarKey = GlobalKey();

  

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
 


  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      
      final data = await _keuanganService.fetchSyahriahDetail(widget.kodeKelas);
      
      if (mounted) {
        setState(() {
          _data = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Gagal memuat data. Periksa koneksi internet Anda.';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataKelas = _data?.dataKelas;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Syahriah', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(dataKelas),
    );
  }

  Widget _buildBody(dynamic dataKelas) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B913B)),
            ),
            SizedBox(height: 16),
            Text('Memuat data...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _fetchDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B913B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchDetail,
      color: const Color(0xFF5B913B),
      child: Column(
        children: [
          if (dataKelas != null) _buildHeaderSection(dataKelas),
          _buildStatisticsSection(),
          Expanded(
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(dynamic dataKelas) {
    final String imageUrl = (dataKelas.fotoWaliKelas != null && dataKelas.fotoWaliKelas!.isNotEmpty)
        ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${dataKelas.fotoWaliKelas}'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(dataKelas.namaWaliKelas ?? 'Wali Kelas')}&background=0D8ABC&color=fff';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5B913B),
            const Color(0xFF5B913B).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dataKelas.namaKelas ?? 'Kelas Tidak Diketahui',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dataKelas.namaWaliKelas ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    if (_data == null) return const SizedBox.shrink();

    int totalSantri = 0;
    int sudahBayar = 0;
    int belumBayar = 0;

    _data!.santri.forEach((bulan, santriList) {
      totalSantri += santriList.length;
      for (var santri in santriList) {
        if (santri.status.toLowerCase() == 'sudah bayar') {
          sudahBayar++;
        } else {
          belumBayar++;
        }
      }
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total',
              '$totalSantri',
              Icons.people,
              const Color(0xFF5B913B),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _scrollToKey(_sudahBayarKey),
              child: _buildStatItem(
                'Sudah Bayar',
                '$sudahBayar',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _scrollToKey(_belumBayarKey),
              child: _buildStatItem(
                'Belum Bayar',
                '$belumBayar',
                Icons.pending,
                Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    if (_data == null || _data!.santri.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data syahriah',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada data pembayaran syahriah untuk kelas ini',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final widgets = <Widget>[];

    _data!.santri.forEach((status, santriList) {
      if (santriList.isNotEmpty) {
        widgets.add(
        Column(
          key: status.toLowerCase() == 'sudah bayar'
              ? _sudahBayarKey
              : status.toLowerCase() == 'belum bayar'
                  ? _belumBayarKey
                  : null,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                '$status',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...santriList.map((e) => _buildSantriTile(e)).toList(),
            ],
          ),
        );
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }



  Widget _buildSantriTile(dynamic santri) {
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  (santri.photo != null && santri.photo!.isNotEmpty)
                      ? '$imageBaseUrl${santri.photo}'
                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=0D8ABC&color=fff',
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    santri.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          santri.tanggalBayar.isNotEmpty
                              ? '${santri.tanggalBayar}'
                              : 'Belum bayar',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(santri.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                santri.status,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sudah bayar':
        return Colors.green;
      case 'belum bayar':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}