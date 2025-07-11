import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/bayar_bulan_lalu_model.dart';
import '../../services/bayar_bulan_lalu_service.dart';
import '../../utils/currency_formatter.dart';

class BayarBulanLaluScreen extends StatefulWidget {
  const BayarBulanLaluScreen({super.key});

  @override
  State<BayarBulanLaluScreen> createState() => _BayarBulanLaluScreenState();
}

class _BayarBulanLaluScreenState extends State<BayarBulanLaluScreen> {
  final BayarBulanLaluService _service = BayarBulanLaluService();
  List<BayarBulanLalu> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBayarData();
  }

  Future<void> fetchBayarData() async {
    final result = await _service.fetchBayarBulanLalu();
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bayar Bulan Lalu', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(child: Text('Tidak ada data pembayaran bulan lalu'))
              : RefreshIndicator(
                  onRefresh: fetchBayarData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _data[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              item.namaSantri.isNotEmpty
                                  ? item.namaSantri.split(' ').first.characters.first.toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            item.namaSantri,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('No Induk: ${item.noInduk}',
                                  style: GoogleFonts.poppins(fontSize: 12)),
                              Text('Jumlah: ${CurrencyFormatter.format(item.jumlah)}',
                                  style: GoogleFonts.poppins(fontSize: 12)),
                              if (item.catatan.isNotEmpty)
                                Text('Catatan: ${item.catatan}',
                                    style: GoogleFonts.poppins(fontSize: 12)),
                              Text('Atas Nama: ${item.atasNama}',
                                  style: GoogleFonts.poppins(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
