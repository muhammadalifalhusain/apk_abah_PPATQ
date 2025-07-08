import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pegawai_model.dart';
import '../../services/pegawai_service.dart';

class PegawaiScreen extends StatefulWidget {
  const PegawaiScreen({super.key});

  @override
  State<PegawaiScreen> createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  List<PegawaiData> _pegawaiList = [];
  bool _isLoading = true;

  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

  @override
  void initState() {
    super.initState();
    _loadPegawai();
  }

  Future<void> _loadPegawai() async {
    final pegawai = await PegawaiService().fetchPegawaiData();
    setState(() {
      _pegawaiList = pegawai;
      _isLoading = false;
    });
  }

  Widget _buildPegawaiCard(PegawaiData pegawai) {
    final imageUrl = pegawai.photo == 'default.png'
        ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(pegawai.nama)}&background=0D8ABC&color=fff'
        : '$imageBaseUrl${pegawai.photo}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 55),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pegawai.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pegawai.jenisKelamin,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Pegawai',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pegawaiList.isEmpty
              ? const Center(child: Text('Data pegawai tidak tersedia'))
              : RefreshIndicator(
                  onRefresh: _loadPegawai,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pegawaiList.length,
                    itemBuilder: (context, index) {
                      final pegawai = _pegawaiList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildPegawaiCard(pegawai),
                      );
                    },
                  ),
                ),
    );
  }
}
