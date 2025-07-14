import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/dawuh_service.dart';
import '../../models/dawuh_model.dart';
import 'add_dawuh_screen.dart';
import 'package:flutter_html/flutter_html.dart';

class DawuhScreen extends StatefulWidget {
  const DawuhScreen({Key? key}) : super(key: key);

  @override
  _DawuhScreenState createState() => _DawuhScreenState();
}

class _DawuhScreenState extends State<DawuhScreen> {
  late Future<List<DawuhAbah>> _dawuhFuture;
  final DawuhService _dawuhService = DawuhService();

  @override
  void initState() {
    super.initState();
    _dawuhFuture = _dawuhService.fetchDawuh();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dawuhFuture = _dawuhService.fetchDawuh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dawuh Abah', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B), 
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: FutureBuilder<List<DawuhAbah>>(
        future: _dawuhFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          } else {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildDawuhCard(snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildLoadingState() => const Center(child: CircularProgressIndicator());

  Widget _buildErrorState(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildEmptyState() {
    return Center(child: Text('Belum ada dawuh'));
  }

  Widget _buildDawuhCard(DawuhAbah dawuh) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dawuh.foto.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://api.ppatq-rf.id/assets/upload/dawuh-abah/${dawuh.foto}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dawuh.judul,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Html(
                  data: dawuh.isiDakwah,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14.0),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black87,
                      lineHeight: LineHeight.number(1.5),
                    ),
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddDawuhScreen(editDawuh: dawuh),
                          ),
                        );

                        if (result == true) {
                          await _refreshData();
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      label: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(dawuh.id),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Konfirmasi Hapus',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus dawuh ini?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () async {
              final success = await _dawuhService.deleteDawuh(id);

              if (success) {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dawuh berhasil dihapus')),
                );
                await _refreshData(); 
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus dawuh')),
                );
              }
            },
            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddDawuhScreen()),
        );
        if (result == true) {
          await _refreshData();
        }
      },
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Tambah Dawuh',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF5B913B), 
    );
  }

}
