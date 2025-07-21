import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tahfidz_model.dart';
import '../../services/tahfidz_service.dart';
import 'detail_tahfidz_screen.dart';

class TahfidzScreen extends StatefulWidget {
  const TahfidzScreen({super.key});

  @override
  State<TahfidzScreen> createState() => _TahfidzScreenState();
}

class _TahfidzScreenState extends State<TahfidzScreen> {
  final KelasTahfidzService _service = KelasTahfidzService();
  final TextEditingController _searchController = TextEditingController();
  List<KelasTahfidz> _kelasList = [];
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchKelasTahfidz();
  }

  Future<void> fetchKelasTahfidz({String? search}) async {
    setState(() => _isLoading = true);
    final response = await _service.fetchKelasTahfidz(search: search);
    setState(() {
      _kelasList = response?.data ?? [];
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchKelasTahfidz(search: value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Cari nama tahfidz...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color.fromARGB(255, 201, 199, 199),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 96, 31),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Kelas Tahfidz',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 5),
                Text('${_kelasList.length}',
                    style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasCard(KelasTahfidz kelas, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTahfidzScreen(idTahfidz: kelas.id.toString()),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF254B62),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${kelas.guruTahfidz}',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text('Tidak ada data kelas tahfidz', style: GoogleFonts.poppins(color: Colors.grey[600])),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF667eea)),
          const SizedBox(height: 20),
          Text('Memuat Data Kelas...',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Tahfidz', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: () => fetchKelasTahfidz(search: _searchController.text),
              color: const Color(0xFF667eea),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  _buildStatCard(),
                  const SizedBox(height: 8),
                  _buildSearchField(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Daftar Kelas',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF2D3748)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (_kelasList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildEmptyState(),
                    )
                  else
                    ..._kelasList.asMap().entries.map((entry) {
                      return _buildKelasCard(entry.value, entry.key);
                    }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
