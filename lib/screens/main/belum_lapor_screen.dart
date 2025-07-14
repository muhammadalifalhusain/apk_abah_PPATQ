import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/belum_lapor_model.dart';
import '../../services/belum_lapor_service.dart';

class BelumLaporScreen extends StatefulWidget {
  const BelumLaporScreen({Key? key}) : super(key: key);

  @override
  State<BelumLaporScreen> createState() => _BelumLaporScreenState();
}

class _BelumLaporScreenState extends State<BelumLaporScreen> {
  final BelumLaporService _belumLaporService = BelumLaporService();
  List<BelumLaporData> _belumLaporList = [];
  bool _isLoading = true;

  final String _basePhotoUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';

  @override
  void initState() {
    super.initState();
    _fetchBelumLapor();
  }

  Future<void> _fetchBelumLapor() async {
    final data = await _belumLaporService.fetchBelumLaporData();
    setState(() {
      _belumLaporList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Belum Lapor', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _belumLaporList.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada data santri yang belum lapor.',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchBelumLapor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _belumLaporList.length,
                    itemBuilder: (context, index) {
                      final santri = _belumLaporList[index];
                      final photoUrl = (santri.photo.isNotEmpty)
                          ? '$_basePhotoUrl${santri.photo}'
                          : null;

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: photoUrl != null && photoUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: NetworkImage(photoUrl),
                                onBackgroundImageError: (_, __) {},
                              )
                            : CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey[200],
                                child: Text(
                                  santri.nama.isNotEmpty ? santri.nama[0] : '?',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                          title: Text(
                            santri.nama,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'No Induk: ${santri.noInduk}',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),

                      );
                    },
                  ),
                ),
    );
  }
}
