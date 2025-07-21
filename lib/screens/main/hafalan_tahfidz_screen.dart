import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tahfidz_model.dart';
import '../../services/tahfidz_service.dart';

class HafalanSantriScreen extends StatefulWidget {
  final String noInduk;

  const HafalanSantriScreen({super.key, required this.noInduk});

  @override
  State<HafalanSantriScreen> createState() => _HafalanSantriScreenState();
}

class _HafalanSantriScreenState extends State<HafalanSantriScreen> {
  late Future<SantriHafalanResponse?> _futureHafalan;

  @override
  void initState() {
    super.initState();
    _futureHafalan = KelasTahfidzService().fetchHafalan(widget.noInduk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Detail Hafalan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<SantriHafalanResponse?>(
        future: _futureHafalan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data?.data;
          if (data == null || data.data.isEmpty) {
            return _buildEmptyKetahfidzan();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.data.length,
            itemBuilder: (context, index) {
              final item = data.data[index];
              bool isExpanded = index == 0;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.grey[50]!],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 56, 96, 31),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.book, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${item.namaBulan} ${item.tahun} - ${item.juz}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDataItem(Icons.bookmark, "Hafalan", item.hafalan),
                                  _buildDataItem(Icons.mic, "Tilawah", item.tilawah),
                                  _buildDataItem(Icons.auto_awesome, "Kefasihan", item.kefasihan),
                                  _buildDataItem(Icons.memory, "Daya Ingat", item.dayaIngat),
                                  _buildDataItem(Icons.speed, "Kelancaran", item.kelancaran),
                                  _buildDataItem(Icons.graphic_eq, "Praktek Tajwid", item.praktekTajwid),
                                  _buildDataItem(Icons.record_voice_over, "Makhroj", item.makhroj),
                                  _buildDataItem(Icons.compare, "Tanafus", item.tanafus),
                                  _buildDataItem(Icons.pause, "Waqof & Wasol", item.waqofWasol),
                                  _buildDataItem(Icons.warning, "Ghorib", item.ghorib),
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
          );
        },
      ),
    );
  }

  Widget _buildDataItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: (value?.isNotEmpty ?? false) ? value : "-",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyKetahfidzan() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada data ketahfidzan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riwayat hafalan akan muncul di sini',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
