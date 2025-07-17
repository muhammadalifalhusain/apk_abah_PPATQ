import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kurban_model.dart';
import '../../services/kurban_service.dart';

// ===================== KURBAN SUMMARY SCREEN =====================
class KurbanSummaryScreen extends StatefulWidget {
  const KurbanSummaryScreen({super.key});

  @override
  State<KurbanSummaryScreen> createState() => _KurbanSummaryScreenState();
}

class _KurbanSummaryScreenState extends State<KurbanSummaryScreen> {
  final KurbanService _kurbanService = KurbanService();
  QurbanSummaryResponse? _summaryData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final data = await _kurbanService.fetchDataKurban();
      
      if (mounted) {
        setState(() {
          _summaryData = data;
          isLoading = false;
          if (data == null) {
            error = 'Gagal memuat data kurban';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Terjadi kesalahan saat memuat data';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurban', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
            ),
            SizedBox(height: 16),
            Text('Memuat data kurban...'),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchSummary,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_summaryData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data kurban',
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
      onRefresh: _fetchSummary,
      color: const Color(0xFF8B4513),
      child: Column(
        children: [
          // Header Section
          _buildHeaderSection(),
          
          // Statistics Section
          _buildStatisticsSection(),
          
          // Content Section
          Expanded(
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kurban',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tahun Hijriah ${_summaryData!.data.tahunHijriah} H',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final totalKurban = _summaryData!.data.data.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );

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
              'Total Data Kurban',
              '$totalKurban',
               Colors.black,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: _buildStatItem(
              'Jenis Hewan',
              '${_summaryData!.data.data.length}',
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
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
    if (_summaryData!.data.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data kurban',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _summaryData!.data.data.length,
      itemBuilder: (context, index) {
        final item = _summaryData!.data.data[index];
        return _buildKurbanTile(item);
      },
    );
  }

  Widget _buildKurbanTile(QurbanSummaryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KurbanDetailScreen(
                kodeJenis: item.jenis,
                jenisHewan: item.viewJenis,
                tahunHijriah: _summaryData!.data.tahunHijriah,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.viewJenis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jumlah kurban terdaftar',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.total}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Ekor',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAnimalIcon(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'sapi':
        return Icons.agriculture;
      case 'kambing':
        return Icons.pets;
      case 'domba':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }
}

// ===================== KURBAN DETAIL SCREEN =====================
class KurbanDetailScreen extends StatefulWidget {
  final int kodeJenis;
  final String jenisHewan;
  final int tahunHijriah;

  const KurbanDetailScreen({
    super.key,
    required this.kodeJenis,
    required this.jenisHewan,
    required this.tahunHijriah,
  });

  @override
  State<KurbanDetailScreen> createState() => _KurbanDetailScreenState();
}

class _KurbanDetailScreenState extends State<KurbanDetailScreen> {
  final KurbanService _kurbanService = KurbanService();
  QurbanDetailResponse? _detailData;
  bool isLoading = true;
  String? error;
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

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

      final data = await _kurbanService.fetchDetailKurban(widget.kodeJenis);
      
      if (mounted) {
        setState(() {
          _detailData = data;
          isLoading = false;
          if (data == null) {
            error = 'Gagal memuat detail kurban';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Terjadi kesalahan saat memuat data';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kurban', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
            ),
            SizedBox(height: 16),
            Text('Memuat detail kurban...'),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_detailData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
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
      color: const Color(0xFF8B4513),
      child: Column(
        children: [
          _buildHeaderSection(),
          _buildStatisticsSection(),
          Expanded(
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.jenisHewan,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tahun Hijriah ${widget.tahunHijriah} H',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.people, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Peserta: ${_detailData!.data.data.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    if (_detailData!.data.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data peserta',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _detailData!.data.data.length,
      itemBuilder: (context, index) {
        final item = _detailData!.data.data[index];
        return _buildPesertaTile(item);
      },
    );
  }

  Widget _buildPesertaTile(QurbanDetailItem item) {
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
                  (item.photo != null && item.photo!.isNotEmpty)
                      ? '$imageBaseUrl${item.photo}'
                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(item.nama)}&background=8B4513&color=fff',
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item.nama,
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
                          'Atas nama: ${item.atasNama}',
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
            
            // Jumlah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF8B4513),
                  width: 1,
                ),
              ),
              child: Text(
                '${item.jumlah} ekor',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAnimalIcon(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'sapi':
        return Icons.agriculture;
      case 'kambing':
        return Icons.pets;
      case 'domba':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }
}