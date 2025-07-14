import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pegawai_model.dart';
import '../../services/pegawai_service.dart';

class DetailPegawaiScreen extends StatefulWidget {
  final int idPegawai;

  const DetailPegawaiScreen({super.key, required this.idPegawai});

  @override
  State<DetailPegawaiScreen> createState() => _DetailPegawaiScreenState();
}

class _DetailPegawaiScreenState extends State<DetailPegawaiScreen> {
  final PegawaiService _pegawaiService = PegawaiService();
  PegawaiDetail? _pegawaiDetail;
  bool _isLoading = true;

  static const String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

  @override
  void initState() {
    super.initState();
    _loadDetailPegawai();
  }

  Future<void> _loadDetailPegawai() async {
    final detail = await _pegawaiService.fetchDetailPegawai(widget.idPegawai);
    print('NAMA => ${detail?.dataDiri.nama}'); 
    setState(() {
      _pegawaiDetail = detail;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Detail Pegawai', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pegawaiDetail == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        "Data tidak tersedia",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDetailPegawai,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDataDiriCard(_pegawaiDetail!.dataDiri),
                        if (_pegawaiDetail!.ketahfidzan.isNotEmpty) ...[
                          _buildSectionHeader("Santri Binaan", _pegawaiDetail!.ketahfidzan.length),
                          const SizedBox(height: 4),
                          ..._pegawaiDetail!.ketahfidzan
                              .map((santri) => _buildSantriCard(santri))
                              .toList(),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.indigo, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade800,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDiriCard(PegawaiDetailDataDiri data) {
    final photoUrl = (data.photo != 'default.png' && data.photo.isNotEmpty)
        ? "$imageBaseUrl${data.photo}"
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(data.nama)}&background=0D8ABC&color=fff";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        shadowColor: Colors.indigo.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.indigo.shade50.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              children: [
                // Foto profil
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade300, Colors.indigo.shade600],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      photoUrl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.nama,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.indigo.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.namaJabatan,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Data diri section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.cake, "Tempat, Tgl Lahir", "${data.tempatLahir}, ${data.tanggalLahir}"),
                      _buildDetailRow(Icons.person, "Kelamin", data.jenisKelamin),
                      _buildDetailRow(Icons.book, "Al-Hafidz", data.alhafidz),
                      _buildDetailRow(Icons.location_on, "Alamat", data.alamat),
                      _buildDetailRow(Icons.school, "Pendidikan", data.pendidikan),
                      _buildDetailRow(Icons.work, "Pengangkatan", data.pengangkatan),
                      _buildDetailRow(Icons.business, "Lembaga Induk", data.lembagaInduk, isLast: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // kanan kiri mepet, atas bawah lebih lega
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Divider(height: 1, color: Colors.grey.shade300),
            ),
        ],
      ),
    );
  }



  Widget _buildSantriCard(KetahfidzanSantri santri) {
    final photoUrl = (santri.photo != 'default.png' && santri.photo.isNotEmpty)
        ? "$imageBaseUrl${santri.photo}"
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=0D8ABC&color=fff";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.indigo.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Colors.indigo.shade50.withOpacity(0.2),
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.indigo.shade300, Colors.indigo.shade600],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                photoUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          title: Text(
            santri.nama,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.indigo.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Kelas: ${santri.kelas}",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "JK: ${santri.jenisKelamin}",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.indigo.shade400,
          ),
        ),
      ),
    );
  }
}