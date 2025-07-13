import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  final KelasService _kelasService = KelasService();
  late Future<List<Kelas>> _kelasListFuture;

  @override
  void initState() {
    super.initState();
    _kelasListFuture = _kelasService.fetchKelasList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Kelas>>(
        future: _kelasListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final kelasList = snapshot.data ?? [];

          if (kelasList.isEmpty) {
            return const Center(
              child: Text('Tidak ada data kelas tersedia'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: kelasList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final kelas = kelasList[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo.shade50,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade300,
                    child: Text(
                      kelas.kode.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(
                    kelas.namaKelas,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Wali Kelas: ${kelas.guru}',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
