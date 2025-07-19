import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kamar_model.dart';
import '../../services/kamar_service.dart';
import 'detail_santri_murroby_screen.dart';
class DetailKamarScreen extends StatefulWidget {
  final String idKamar;

  const DetailKamarScreen({super.key, required this.idKamar});

  @override
  State<DetailKamarScreen> createState() => _DetailKamarScreenState();
}

class _DetailKamarScreenState extends State<DetailKamarScreen> {
  final KamarService _service = KamarService();
  late Future<KamarDetailResponse?> _kamarDetailFuture;

  @override
  void initState() {
    super.initState();
    _kamarDetailFuture = _service.fetchKamarDetail(widget.idKamar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kamar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<KamarDetailResponse?>(
        future: _kamarDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat data'));
          }

          final detail = snapshot.data!;
          final dataKamar = detail.data.dataKamar;
          final santriList = detail.data.santri;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (dataKamar != null) ...[
                _buildKamarCard(dataKamar),
                const SizedBox(height: 16),
              ],
              Text(
                'Jumlah Santri: ${santriList.length}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ...santriList.map((santri) => _buildSantriTile(context, santri)).toList()
            ],
          );
        },
      ),
    );
  }

  Widget _buildKamarCard(DataKamarDetail  kamar) {
    final imageUrl = kamar.fotoMurroby.isNotEmpty
        ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${kamar.fotoMurroby}'
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null ? const Icon(Icons.person, size: 32, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kamar.namaMurroby,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Kamar: ${kamar.namaKamar}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSantriTile(BuildContext context, Santri santri) {
    final String? photo = santri.photo;
    final bool hasPhoto = photo != null && photo.isNotEmpty;
    final String? photoUrl = hasPhoto
        ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/$photo'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.indigo.shade100,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? Icon(
                  santri.jenisKelamin == 'L' ? Icons.male : Icons.female,
                  color: Colors.indigo,
                )
              : null,
        ),
        title: Text(
          santri.nama,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asal: ${santri.asalKota}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Capaian: ${santri.capaian}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          tooltip: 'Lihat Detail',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSantriMurrobyScreen(noInduk: santri.noInduk),
              ),
            );
          },
        ),
      ),
    );
  }
}
