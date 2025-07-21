import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tahfidz_model.dart';
import '../../services/tahfidz_service.dart';
import 'hafalan_tahfidz_screen.dart';
class DetailTahfidzScreen extends StatefulWidget {
  final String idTahfidz;

  const DetailTahfidzScreen({super.key, required this.idTahfidz});

  @override
  State<DetailTahfidzScreen> createState() => _DetailTahfidzScreenState();
}

class _DetailTahfidzScreenState extends State<DetailTahfidzScreen> {
  final KelasTahfidzService _service = KelasTahfidzService();
  TahfidzDetailResponse? _detailData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    final response = await _service.fetchTahfidzDetail(widget.idTahfidz);
    setState(() {
      _detailData = response;
      _isLoading = false;
    });
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.indigo),
    );
  }

  Widget _buildHeader(DataTahfidzDetail data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: data.fotoGuruTahfidz.isNotEmpty
                ? NetworkImage(
                    'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${data.fotoGuruTahfidz}',
                  )
                : null,
            child: data.fotoGuruTahfidz.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.namaGuruTahfidz,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.namaKelasTahfidz,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAchievementCard(CapaianTertinggi? capaian) {
    if (capaian == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Capaian Tertinggi',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            '${capaian.capaian} - ${capaian.jumlahSantri} Santri',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5B913B),
            ),
          ),
          if (capaian.listSantriTertinggi.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...capaian.listSantriTertinggi.map((santri) {
                  final imageUrl = (santri.photo != null && santri.photo!.isNotEmpty)
                      ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}'
                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.namaSantri)}';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          santri.namaSantri,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSantriItem(BuildContext context, SantriTahfidz santri) {
    final String imageUrl = (santri.photo != null && santri.photo!.isNotEmpty)
        ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  santri.nama,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Capaian: ${santri.capaianTerakhir?.isNotEmpty == true ? santri.capaianTerakhir : '-'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: Colors.indigo),
            tooltip: "Lihat Hafalan",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HafalanSantriScreen(noInduk: santri.noInduk.toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detailData?.data;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Detail Tahfidz',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? _buildLoading()
          : detail == null
              ? Center(
                  child: Text(
                    'Data tidak tersedia',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchDetail,
                  color: const Color(0xFF5B913B),
                  child: ListView(
                    children: [
                      _buildHeader(detail.dataTahfidz!),
                      _buildAchievementCard(detail.capaianTertinggi),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daftar Santri',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                            Text(
                              'Total: ${_detailData?.jumlah ?? 0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...detail.santri.map((santri) => _buildSantriItem(context, santri)).toList(),
                    ],
                  ),
                ),
    );
  }
}