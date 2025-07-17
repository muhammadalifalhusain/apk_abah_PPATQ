import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/santri_model.dart';
import '../../services/santri_service.dart';
import 'detail_santri_screen.dart';

class SantriScreen extends StatefulWidget {
  const SantriScreen({super.key});

  @override
  State<SantriScreen> createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen> {
  final SantriService _service = SantriService();
  final String imageBaseUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Santri> _santriList = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isFetchingMore = false;
  Timer? _debounce;

  int _currentPage = 1;
  int _lastPage = 1;
  String? _nextPageUrl;

  @override
  void initState() {
    super.initState();
    _fetchSantriData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (_nextPageUrl != null && !_isFetchingMore && !_isSearching) {
          _fetchMoreSantri();
        }
      }
    });

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _currentPage = 1;
        _fetchSantriData(search: _searchController.text);
      });
    });
  }

  Future<void> _fetchSantriData({String? search}) async {
    setState(() {
      _isLoading = true;
    });

    final response = await _service.fetchSantriData(search: search);

    setState(() {
      _santriList = response.data;
      _currentPage = response.currentPage;
      _lastPage = response.lastPage;
      _nextPageUrl = response.nextPageUrl;
      _isLoading = false;
    });
  }

  Future<void> _fetchMoreSantri() async {
    if (_nextPageUrl == null || _isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    final moreData = await _service.fetchSantriByUrl(_nextPageUrl!);
    setState(() {
      _santriList.addAll(moreData.data);
      _currentPage = moreData.currentPage;
      _nextPageUrl = moreData.nextPageUrl;
      _isFetchingMore = false;
    });
  }

  Widget _buildSantriCard(Santri santri) {
    final photoUrl = (santri.photo.isNotEmpty && santri.photo != 'default.png')
        ? '$imageBaseUrl${santri.photo}'
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=0D8ABC&color=fff';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SantriDetailScreen(noInduk: santri.noInduk),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
                      santri.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      santri.jenisKelamin,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Kelas: ${santri.kelas}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Wali Kelas: ${santri.waliKelas}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: 3.14, 
                child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
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
        title: Text('Data Santri', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama santri...',
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
                          _fetchSantriData();
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
                : _santriList.isEmpty
                    ? const Center(child: Text('Tidak ada data santri'))
                    : RefreshIndicator(
                        onRefresh: () => _fetchSantriData(search: _searchController.text),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _santriList.length + (_isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < _santriList.length) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildSantriCard(_santriList[index]),
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
