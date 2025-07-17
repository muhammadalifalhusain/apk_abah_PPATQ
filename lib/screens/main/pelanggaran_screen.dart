import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pelanggaran_model.dart';
import '../../services/pelanggaran_service.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({Key? key}) : super(key: key);

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  final PelanggaranService _service = PelanggaranService();
  final TextEditingController _searchController = TextEditingController();
  List<Pelanggaran> _pelanggaranList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({String? search}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final response = await _service.fetchPelanggaran(search: search);
    if (response != null && response.data.isNotEmpty) {
      setState(() {
        _pelanggaranList = response.data;
        isLoading = false;
      });
    } else {
      setState(() {
        _pelanggaranList = [];
        isLoading = false;
        errorMessage = 'Data tidak ditemukan.';
      });
    }
  }

  void _showDetailDialog(Pelanggaran item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Detail Pelanggaran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Nama", item.nama),
            _buildDetailRow("Tanggal", item.tanggal),
            _buildDetailRow("Jenis Pelanggaran", item.jenisPelanggaran),
            _buildDetailRow("Kategori", item.kategori),
            _buildDetailRow("Hukuman", item.hukuman),
            _buildDetailRow("Bukti", item.bukti),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(color: Colors.black),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: (value?.isNotEmpty ?? false) ? value! : "-",
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
        title: Text('Data Pelanggaran', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadData();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) => _loadData(search: value.trim()),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pelanggaranList.isEmpty
                    ? Center(child: Text(errorMessage, style: GoogleFonts.poppins()))
                    : ListView.builder(
                        itemCount: _pelanggaranList.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final item = _pelanggaranList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            child: ListTile(
                              title: Text(item.nama, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.jenisPelanggaran, style: GoogleFonts.poppins()),
                                  Text("${item.tanggal}", style: GoogleFonts.poppins(fontSize: 12)),
                                ],
                              ),
                              trailing: Text(item.kategori, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                              onTap: () => _showDetailDialog(item),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
