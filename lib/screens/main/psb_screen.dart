import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/psb_model.dart';
import '../../services/psb_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PsbScreen extends StatefulWidget {
  const PsbScreen({super.key});

  @override
  State<PsbScreen> createState() => _PsbScreenState();
}

class _PsbScreenState extends State<PsbScreen> {
  final PsbService _psbService = PsbService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<PsbData> _psbList = [];
  bool _isLoading = true;
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchPsb();

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        fetchPsb(search: _searchController.text);
      });
    });
  }

  Future<void> fetchPsb({String? search}) async {
    if (search != null) setState(() => _isSearching = true);
    final data = await _psbService.fetchPsbData(search: search);
    setState(() {
      _psbList = data;
      _isLoading = false;
      _isSearching = false;
    });
  }

  Widget _buildPsbItem(PsbData psb) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: psb.jenisKelamin == 'Laki-laki' ? Colors.blue : Colors.pink,
          child: Icon(
            psb.jenisKelamin == 'Laki-laki' ? Icons.male : Icons.female,
            color: Colors.white,
          ),
        ),
        title: Text(psb.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Asal: ${psb.asal}'),
        trailing: Text(psb.jenisKelamin, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Data PSB',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau asal...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          fetchPsb(); // reset data
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _psbList.isEmpty
                    ? const Center(child: Text('Data PSB tidak ditemukan'))
                    : RefreshIndicator(
                        onRefresh: () => fetchPsb(search: _searchController.text),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _psbList.length,
                          itemBuilder: (context, index) {
                            return _buildPsbItem(_psbList[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
