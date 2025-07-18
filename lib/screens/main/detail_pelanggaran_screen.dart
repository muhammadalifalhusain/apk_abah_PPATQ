import 'package:flutter/material.dart';
import '../../models/pelanggaran_model.dart';
import '../../services/pelanggaran_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPelanggaranScreen extends StatefulWidget {
  final String kodeKategori;

  const DetailPelanggaranScreen({Key? key, required this.kodeKategori}) : super(key: key);

  @override
  State<DetailPelanggaranScreen> createState() => _DetailPelanggaranScreenState();
}

class _DetailPelanggaranScreenState extends State<DetailPelanggaranScreen> {
  final PelanggaranService _service = PelanggaranService();
  bool _isLoading = true;
  List<DetailPelanggaranItem> _detailList = [];

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  void _fetchDetail() async {
    final response = await _service.fetchDetailPelanggaran(widget.kodeKategori);
    if (response != null) {
      setState(() {
        _detailList = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pelanggaran', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detailList.isEmpty
              ? const Center(child: Text('Tidak ada data pelanggaran.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _detailList.length,
                  itemBuilder: (context, index) {
                    final item = _detailList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          item.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tanggal: ${item.tanggal}"),
                            Text("Jenis: ${item.jenisPelanggaran}"),
                            Text("Kategori: ${item.kategori}"),
                            Text("Hukuman: ${item.hukuman}"),
                            if (item.bukti != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  item.bukti!,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
