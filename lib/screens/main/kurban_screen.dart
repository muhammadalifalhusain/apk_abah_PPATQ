import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kurban_model.dart';
import '../../services/kurban_service.dart';

class KurbanScreen extends StatefulWidget {
  const KurbanScreen({super.key});

  @override
  State<KurbanScreen> createState() => _KurbanScreenState();
}

class _KurbanScreenState extends State<KurbanScreen> {
  final KurbanService _service = KurbanService();
  List<Kurban> _kurbanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKurbanData();
  }

  Future<void> fetchKurbanData() async {
    final data = await _service.fetchKurbanData();
    setState(() {
      _kurbanList = data;
      _isLoading = false;
    });
  }

  Widget _buildKurbanCard(Kurban item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.volunteer_activism, color: Colors.redAccent),
        title: Text(item.namaSantri,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Atas Nama: ${item.atasNama}', style: GoogleFonts.poppins()),
            Text('${item.jenis}', style: GoogleFonts.poppins()),
            Text('Tanggal: ${item.tanggal}', style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kurban',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kurbanList.isEmpty
              ? const Center(child: Text('Data kurban tidak tersedia'))
              : RefreshIndicator(
                  onRefresh: fetchKurbanData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _kurbanList.length,
                    itemBuilder: (context, index) =>
                        _buildKurbanCard(_kurbanList[index]),
                  ),
                ),
    );
  }
}
