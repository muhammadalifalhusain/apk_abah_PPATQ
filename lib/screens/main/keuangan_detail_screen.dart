import 'package:flutter/material.dart';
import '../../models/keuangan_model.dart';
import '../../services/keuangan_service.dart';
import 'package:google_fonts/google_fonts.dart';

class KeuanganDetailScreen extends StatefulWidget {
  final String kodeKelas;

  const KeuanganDetailScreen({super.key, required this.kodeKelas});

  @override
  State<KeuanganDetailScreen> createState() => _KeuanganDetailScreenState();
}

class _KeuanganDetailScreenState extends State<KeuanganDetailScreen> {
  late Future<DataUangSaku> _futureData;
  final GlobalKey _minusSectionKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  void _scrollToMinusSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _minusSectionKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1, 
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _futureData = KeuanganService().fetchSakuByKelas(widget.kodeKelas);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Saku', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DataUangSaku>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Periksa koneksi internet Anda',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureData = KeuanganService().fetchSakuByKelas(widget.kodeKelas);
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final kelas = data.dataKelas;
          final surplusList = data.surplus ?? [];
          final minusList = data.minus ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureData = KeuanganService().fetchSakuByKelas(widget.kodeKelas);
              });
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  if (kelas != null) _buildHeaderSection(kelas),
                  
                  _buildStatisticsSection(
                    surplusList,
                    minusList,
                    onTapMinus: _scrollToMinusSection,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Surrplus Section
                        if (surplusList.isNotEmpty) ...[
                          _buildSectionHeader(
                            'Santri Surplus',
                            '${surplusList.length} orang',
                          ),
                          const SizedBox(height: 12),
                          ...surplusList.map((santri) => _buildSantriTile(santri)),
                        ],
                        if (minusList.isNotEmpty) ...[
                          Container(
                            key: _minusSectionKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  'Santri Minus',
                                  '${minusList.length} orang',
                                ),
                                const SizedBox(height: 12),
                                ...minusList.map((santri) => _buildSantriTile(santri)),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                        // Empty State
                        if (surplusList.isEmpty && minusList.isEmpty) ...[
                          const SizedBox(height: 40),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada data santri',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Belum ada data keuangan untuk kelas ini',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(dynamic kelas) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31), // Warna utama background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Ikuti referensi styling
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.class_,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  kelas.namaKelas ?? 'Kelas Tidak Diketahui',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Wali : ${kelas.namaWaliKelas ?? '-'}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatisticsSection(
    List<dynamic> surplusList,
    List<dynamic> minusList, {
    VoidCallback? onTapMinus,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Surplus',
            '${surplusList.length}',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: minusList.isNotEmpty ? onTapMinus : null,
            borderRadius: BorderRadius.circular(12),
            child: _buildStatItem(
              'Minus',
              '${minusList.length}',
              Icons.trending_down,
              Colors.red,
            ),
          ),
        ),
        Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Total',
              '${surplusList.length + minusList.length}',
              Icons.people,
              Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }


  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSantriTile(SantriUang santri) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  santri.photo != null && santri.photo!.isNotEmpty
                    ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}'
                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama.toString())}&background=0D8ABC&color=fff',
                ),
              ),

            ),
            const SizedBox(width: 10),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    santri.namaFormatted,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              santri.jenisKelaminFormatted ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Murroby: ${santri.murrobyFormatted ?? '-'}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (santri.uangMasuk != null || santri.uangKeluar != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Masuk: ${santri.totalUangMasuk ?? "-"}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Keluar: ${santri.totalUangKeluar ?? "-"}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.red,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (santri.isMinus ? Colors.red : Colors.green).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: santri.isMinus ? Colors.red : Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          santri.saldoFormatted ?? '${santri.saldoFormatted ?? 0}',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: santri.isMinus ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}