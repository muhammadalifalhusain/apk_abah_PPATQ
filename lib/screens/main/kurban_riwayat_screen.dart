import 'package:flutter/material.dart';
import '../../models/kurban_model.dart';
import '../../services/kurban_service.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatKurbanScreen extends StatefulWidget {
  const RiwayatKurbanScreen({super.key});

  @override
  State<RiwayatKurbanScreen> createState() => _RiwayatKurbanScreenState();
}

class _RiwayatKurbanScreenState extends State<RiwayatKurbanScreen> {
  final KurbanService _kurbanService = KurbanService();
  late Future<RiwayatKurbanResponse?> _riwayatFuture;
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';
  
  @override
  void initState() {
    super.initState();
    _riwayatFuture = _kurbanService.fetchRiwayatKurban();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Qurban', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<RiwayatKurbanResponse?>(
        future: _riwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data.isEmpty) {
            return const Center(child: Text('Tidak ada data riwayat kurban.'));
          }

          final items = snapshot.data!.data;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            (item.photo != null && item.photo!.isNotEmpty)
                                ? '$imageBaseUrl${item.photo}'
                                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(item.nama ?? '')}&background=8B4513&color=fff',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama ?? '-',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              '${item.atasNama}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'Jenis : ${item.jenis ?? '-'}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              '${item.jumlah} ekor - ${item.tahunHijriah} Hijriah',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
