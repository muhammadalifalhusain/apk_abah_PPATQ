
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tahfidz_model.dart';
import '../../services/tahfidz_service.dart';

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
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${data.fotoGuruTahfidz}',
            ),
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

  Widget _buildSantriItem(SantriTahfidz santri) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              santri.nama,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
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
        title: Text('Detail Tahfidz', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
              ? Center(child: Text('Data tidak tersedia', style: GoogleFonts.poppins()))
              : RefreshIndicator(
                  onRefresh: _fetchDetail,
                  color: Colors.indigo,
                  child: ListView(
                    children: [
                      _buildHeader(detail.dataTahfidz!),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          'Daftar Santri',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      ...detail.santri.map(_buildSantriItem).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
