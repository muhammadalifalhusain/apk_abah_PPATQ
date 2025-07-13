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
      appBar: AppBar(
        title: Text('Detail Pegawai', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pegawaiDetail == null
              ? const Center(child: Text("Data tidak tersedia"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildDataDiriCard(_pegawaiDetail!.dataDiri),
                      if (_pegawaiDetail!.ketahfidzan.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          "Santri Binaan",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._pegawaiDetail!.ketahfidzan
                            .map((santri) => _buildSantriCard(santri))
                            .toList(),
                      ]
                    ],
                  ),
                ),
    );
  }

  Widget _buildDataDiriCard(PegawaiDetailDataDiri data) {
    final photoUrl = (data.photo != 'default.png' && data.photo.isNotEmpty)
        ? "$imageBaseUrl${data.photo}"
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(data.nama)}&background=0D8ABC&color=fff";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                photoUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 100),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.nama,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _buildDetailRow("Tempat, Tgl Lahir", "${data.tempatLahir}, ${data.tanggalLahir}"),
            _buildDetailRow("Jenis Kelamin", data.jenisKelamin),
            _buildDetailRow("Jabatan", data.namaJabatan),
            _buildDetailRow("Al-Hafidz", data.alhafidz),
            _buildDetailRow("Alamat", data.alamat),
            _buildDetailRow("Pendidikan", data.pendidikan),
            _buildDetailRow("Pengangkatan", data.pengangkatan),
            _buildDetailRow("Lembaga Induk", data.lembagaInduk),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: GoogleFonts.poppins(),
            ),
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            photoUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 48),
          ),
        ),
        title: Text(
          santri.nama,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "Kelas: ${santri.kelas} | JK: ${santri.jenisKelamin}",
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
  }
}
