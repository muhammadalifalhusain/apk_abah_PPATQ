import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/santri_model.dart';
import '../../services/santri_service.dart';

class SantriScreen extends StatefulWidget {
  const SantriScreen({super.key});

  @override
  State<SantriScreen> createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen> {
  final SantriService _service = SantriService();
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

  List<Santri> _santriList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSantriData();
  }

  Future<void> _fetchSantriData() async {
    final result = await _service.fetchSantriData();
    setState(() {
      _santriList = result;
      _isLoading = false;
    });
  }

  Widget _buildSantriCard(Santri santri) {
    final photoUrl = (santri.photo.isNotEmpty && santri.photo != 'default.png')
        ? '$imageBaseUrl${santri.photo}'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=0D8ABC&color=fff';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photoUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 55),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    santri.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${santri.jenisKelamin}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                  ),
                  Text(
                    'Kelas: ${santri.kelas}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
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
        title: Text('Data Santri', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _santriList.isEmpty
              ? const Center(child: Text('Tidak ada data santri'))
              : RefreshIndicator(
                  onRefresh: _fetchSantriData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _santriList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSantriCard(_santriList[index]),
                      );
                    },
                  ),
                ),
    );
  }
}
