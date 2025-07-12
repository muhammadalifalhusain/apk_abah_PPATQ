import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/keluhan_service.dart';
import '../../models/keluhan_model.dart';
import 'keluhan_detail.dart';

class KeluhanScreen extends StatefulWidget {
  const KeluhanScreen({super.key});

  @override
  State<KeluhanScreen> createState() => _KeluhanScreenState();
}

class _KeluhanScreenState extends State<KeluhanScreen> {
  final KeluhanService _keluhanService = KeluhanService();
  late Future<KeluhanResponse?> _futureKeluhan;

  @override
  void initState() {
    super.initState();
    _futureKeluhan = _keluhanService.fetchReplyKeluhan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Keluhan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<KeluhanResponse?>(
        future: _futureKeluhan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data keluhan."));
          }

          final keluhanList = [
            ...snapshot.data!.data.belumDitangani,
            ...snapshot.data!.data.ditangani,
          ];


          if (keluhanList.isEmpty) {
            return const Center(child: Text("Tidak ada keluhan yang tersedia."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: keluhanList.length,
            itemBuilder: (context, index) {
              final keluhan = keluhanList[index];

              return Card(
                color: Color(keluhan.statusColorValue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    keluhan.kategori.isNotEmpty ? keluhan.kategori : 'Tanpa Kategori',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        keluhan.masukan.isNotEmpty ? keluhan.masukan : 'Tidak ada masukan.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pelapor: ${keluhan.namaPelapor.isNotEmpty ? keluhan.namaPelapor : 'Tidak diketahui'}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Status: ${keluhan.statusLabel}',
                        style: TextStyle(
                          fontSize: 12,
                          color: keluhan.status == 2 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    keluhan.jenis.toLowerCase() == 'aduan'
                        ? Icons.warning_amber_rounded
                        : Icons.feedback_outlined,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => KeluhanDetail(keluhan: keluhan),
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

