import 'package:flutter/material.dart';
import '../../models/kelengkapan_model.dart';
import '../../services/kelengkapan_service.dart';
import 'package:google_fonts/google_fonts.dart';

class KelengkapanScreen extends StatefulWidget {
  const KelengkapanScreen({Key? key}) : super(key: key);

  @override
  _KelengkapanScreenState createState() => _KelengkapanScreenState();
}

class _KelengkapanScreenState extends State<KelengkapanScreen> {
  late Future<KelengkapanResponse?> _kelengkapanFuture;
  final KelengkapanService _service = KelengkapanService();

  @override
  void initState() {
    super.initState();
    _kelengkapanFuture = _service.fetchKelengkapan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kelengkapan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<KelengkapanResponse?>(
        future: _kelengkapanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _kelengkapanFuture = _service.fetchKelengkapan();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 60),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada data kelengkapan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _kelengkapanFuture = _service.fetchKelengkapan();
                      });
                    },
                    child: const Text('Muat Ulang'),
                  ),
                ],
              ),
            );
          }

          final response = snapshot.data!;
          final data = response.data;
          final items = data.listData;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bulan: ${data.bulan}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                _buildDetailList(items),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailList(List<KelengkapanItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.asMap().entries.map((entry) {
          final item = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Mandi Tidak Lengkap', item.mandiTidakLengkap),
                  _buildDetailRow('Mandi Lengkap Kurang', item.mandiLengkapKurang),
                  _buildDetailRow('Mandi Lengkap Baik', item.mandiLengkapBaik),
                  const Divider(),
                  _buildDetailRow('Sekolah Tidak Lengkap', item.sekolahTidakLengkap),
                  _buildDetailRow('Sekolah Lengkap Kurang', item.sekolahLengkapKurang),
                  _buildDetailRow('Sekolah Lengkap Baik', item.sekolahLengkapBaik),
                  const Divider(),
                  _buildDetailRow('Diri Tidak Lengkap', item.diriTidakLengkap),
                  _buildDetailRow('Diri Lengkap Kurang', item.diriLengkapKurang),
                  _buildDetailRow('Diri Lengkap Baik', item.diriLengkapBaik),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}