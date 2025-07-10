import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kamar_model.dart';
import '../../services/kamar_service.dart';

class KamarScreen extends StatefulWidget {
  const KamarScreen({super.key});

  @override
  State<KamarScreen> createState() => _KamarScreenState();
}

class _KamarScreenState extends State<KamarScreen> {
  final KamarService _service = KamarService();
  List<Kamar> _kamarList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKamar();
  }

  Future<void> fetchKamar() async {
    setState(() => _isLoading = true);
    final data = await _service.fetchKamarData();
    setState(() {
      _kamarList = data;
      _isLoading = false;
    });
  }

  Widget _buildKamarCard(Kamar kamar) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.bedroom_child, color: Colors.indigo, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kamar.namaKelas,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Murroby: ${kamar.murroby}',
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
          'Data Kamar Santri',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kamarList.isEmpty
              ? const Center(child: Text('Data kamar tidak ditemukan'))
              : RefreshIndicator(
                  onRefresh: fetchKamar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _kamarList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildKamarCard(_kamarList[index]),
                      );
                    },
                  ),
                ),
    );
  }
}
