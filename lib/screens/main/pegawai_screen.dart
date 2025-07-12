import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pegawai_model.dart';
import '../../services/pegawai_service.dart';

class PegawaiScreen extends StatefulWidget {
  const PegawaiScreen({super.key});

  @override
  State<PegawaiScreen> createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  final PegawaiService _service = PegawaiService();
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> kategoriList = ['Pegawai', 'Murroby', 'Ustadz-Ustadzah'];

  String selectedKategori = 'Pegawai';
  List<PegawaiData> _dataList = [];
  PegawaiPaginatedData? _currentPageData;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          selectedKategori == 'Pegawai' &&
          _currentPageData?.nextPageUrl != null) {
        _loadMoreData();
      }
    });

    _searchController.addListener(() {
      if (selectedKategori != 'Pegawai') return;
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _loadData(search: _searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadData({String? search}) async {
    setState(() => _isLoading = true);
    if (selectedKategori == 'Pegawai') {
      final data = await _service.fetchPegawaiData(search: search);
      setState(() {
        _currentPageData = data;
        _dataList = data.data;
        _isLoading = false;
      });
    } else if (selectedKategori == 'Murroby') {
      final data = await _service.fetchMurrobyData();
      setState(() {
        _dataList = data;
        _isLoading = false;
      });
    } else if (selectedKategori == 'Ustadz-Ustadzah') {
      final data = await _service.fetchUstadzData();
      setState(() {
        _dataList = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_currentPageData?.nextPageUrl == null) return;
    setState(() => _isLoadingMore = true);

    final nextPageData = await _service.fetchPegawaiByUrl(_currentPageData!.nextPageUrl!);
    setState(() {
      _currentPageData = nextPageData;
      _dataList.addAll(nextPageData.data);
      _isLoadingMore = false;
    });
  }

  Widget _buildItem(PegawaiData item) {
    final String photoUrl = (item.photo.isNotEmpty && item.photo != 'default.png')
        ? '$imageBaseUrl${item.photo}'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(item.nama)}&background=0D8ABC&color=fff';

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
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 55),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.jenisKelamin,
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
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Text(
          selectedKategori,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButtonFormField<String>(
              value: selectedKategori,
              items: kategoriList
                  .map((kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedKategori = value;
                    _searchController.clear();
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
          if (selectedKategori == 'Pegawai')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari nama pegawai...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _loadData();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _dataList.isEmpty
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : RefreshIndicator(
                        onRefresh: () => _loadData(search: _searchController.text),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _dataList.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < _dataList.length) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildItem(_dataList[index]),
                              );
                            } else {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
