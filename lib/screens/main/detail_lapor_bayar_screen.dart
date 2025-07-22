import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lapor_bayar_model.dart';
import '../../services/keuangan_service.dart';

class DetailLaporBayarScreen extends StatefulWidget {
  final String kodeKelas;

  const DetailLaporBayarScreen({super.key, required this.kodeKelas});

  @override
  State<DetailLaporBayarScreen> createState() => _DetailLaporBayarScreenState();
}

class _DetailLaporBayarScreenState extends State<DetailLaporBayarScreen> {
  List<PembayaranItem> _santriList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLaporBayar();
  }

  Future<void> _fetchLaporBayar() async {
    try {
      final response = await KeuanganService().fetchLaporBayar();

      if (response == null) {
        setState(() {
          _error = 'Data tidak tersedia.';
          _isLoading = false;
        });
        return;
      }

      final kelasData = response.data[widget.kodeKelas];

      setState(() {
        _santriList = kelasData ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildJenisPembayaran(Map<String, int> jenisMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: jenisMap.entries
          .where((entry) => entry.value > 0)
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '- ${entry.key}: Rp ${entry.value}',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Lapor Bayar - ${widget.kodeKelas}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _santriList.isEmpty
                  ? const Center(child: Text('Belum ada data pembayaran.'))
                  : ListView.builder(
                      itemCount: _santriList.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = _santriList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.namaSantri,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dibayar oleh: ${item.pengirim}',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                Text(
                                  'Tanggal: ${item.tanggalBayar}',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                Text(
                                  'Periode: ${item.periode}',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                _buildJenisPembayaran(item.jenisPembayaran.entries),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
