import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';

class DetailKelasScreen extends StatefulWidget {
  final String kodeKelas;

  const DetailKelasScreen({super.key, required this.kodeKelas});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  final KelasService _service = KelasService();
  late Future<KelasDetailResponse?> _kelasDetailFuture;

  @override
  void initState() {
    super.initState();
    _kelasDetailFuture = _service.fetchKelasDetail(widget.kodeKelas);
  }

  Future<void> _refreshData() async {
    setState(() {
      _kelasDetailFuture = _service.fetchKelasDetail(widget.kodeKelas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Detail Kelas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<KelasDetailResponse?>(
        future: _kelasDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final detail = snapshot.data!;
          final kamar = detail.data.dataKamar;
          final santriList = detail.data.santri;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info Kelas
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.class_, color: Colors.indigo, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kelas ${widget.kodeKelas.toUpperCase()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jumlah Santri: ${santriList.length}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
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
                if (kamar != null) ...[
                  const SizedBox(height: 8),
                  _buildMurrobyCard(kamar),
                ],
                
                // Santri List
                const SizedBox(height: 8),
                Text(
                  'Daftar Santri',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                
                if (santriList.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada santri',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...santriList.map((santri) => _buildSantriTile(santri)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMurrobyCard(DataKamar kamar) {
    final imageUrl = kamar.fotoMurroby.isNotEmpty
        ? "https://manajemen.ppatq-rf.id/assets/img/upload/photo/${kamar.fotoMurroby}"
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(kamar.namaMurroby)}&background=0D8ABC&color=fff";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Murroby',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kamar.namaMurroby,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kamar: ${kamar.namaKamar}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSantriTile(Santri santri) {
    final hasPhoto = santri.photo != null && santri.photo!.isNotEmpty;
    final imageUrl = hasPhoto
        ? "https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}"
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=0D8ABC&color=fff";

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                santri.jenisKelamin == 'L' ? Icons.male : Icons.female,
                color: Colors.indigo,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          santri.nama,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          santri.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}