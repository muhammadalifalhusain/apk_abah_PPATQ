import 'package:flutter/material.dart';
import '../../models/pelanggaran_model.dart';
import '../../services/pelanggaran_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abah/screens/main/detail_pelanggaran_screen.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({Key? key}) : super(key: key);

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  final PelanggaranService _service = PelanggaranService();
  late Future<RekapPelanggaranResponse?> _futureRekap;

  @override
  void initState() {
    super.initState();
    _futureRekap = _service.fetchRekapPelanggaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pelanggaran', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<RekapPelanggaranResponse?>(
        future: _futureRekap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat data.'));
          }

          final data = snapshot.data!.data;

          if (data.isEmpty) {
            return const Center(child: Text('Tidak ada data pelanggaran.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 56, 96, 31),
                    child: Text(
                      '${item.kategori}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    item.viewKategori,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Jumlah Data: ${item.jumlah}',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPelanggaranScreen(kodeKategori: item.kategori.toString()),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
