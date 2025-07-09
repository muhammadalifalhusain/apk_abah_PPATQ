import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/pegawai_service.dart';

class PegawaiScreen extends StatefulWidget {
  const PegawaiScreen({super.key});

  @override
  State<PegawaiScreen> createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  String selectedKategori = 'Pegawai';
  final List<String> kategoriList = ['Pegawai', 'Murroby'];

  List<dynamic> _dataList = [];
  bool _isLoading = true;

  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    if (selectedKategori == 'Pegawai') {
      final pegawai = await PegawaiService().fetchPegawaiData();
      setState(() {
        _dataList = pegawai;
        _isLoading = false;
      });
    } else {
      final murroby = await PegawaiService().fetchMurrobyData();
      setState(() {
        _dataList = murroby;
        _isLoading = false;
      });
    }
  }

  Widget _buildItem(dynamic item) {
    final String nama = item.nama;
    final String jenisKelamin = item.jenisKelamin;
    final String photo = item.photo;
    final photoUrl = (photo.isNotEmpty && photo != 'default.png')
        ? '$imageBaseUrl$photo'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nama)}&background=0D8ABC&color=fff';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                photoUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 55),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jenisKelamin,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data ${selectedKategori}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButtonFormField<String>(
              value: selectedKategori,
              items: kategoriList
                  .map((kategori) => DropdownMenuItem(value: kategori, child: Text(kategori)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedKategori = value;
                  });
                  _loadData();
                }
              },
              decoration: InputDecoration(
                labelText: 'Pilih Kategori',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _dataList.isEmpty
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _dataList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildItem(_dataList[index]),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
