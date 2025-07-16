import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/keluhan_service.dart';
import '../../models/keluhan_model.dart';
import 'keluhan_detail.dart';

class KeluhanScreen extends StatefulWidget {
  const KeluhanScreen({super.key});

  @override
  State<KeluhanScreen> createState() => _KeluhanScreenState();
}

class _KeluhanScreenState extends State<KeluhanScreen> {
  final KeluhanService _keluhanService = KeluhanService();
  late Future<KeluhanResponse?> _futureKeluhan;
  String? _selectedKategori;

  Map<String, KategoriKeluhan> _kategoriData = {};

  @override
  void initState() {
    super.initState();
    _futureKeluhan = _fetchKeluhanData();
  }

  Future<KeluhanResponse?> _fetchKeluhanData() async {
    final response = await _keluhanService.fetchReplyKeluhan();
    if (response != null) {
      _kategoriData = response.data;
    }
    return response;
  }

  void _updateKeluhanInList(KeluhanItem updated) {
    final kategoriKey = _selectedKategori ?? _kategoriData.keys.first;

    final list = _kategoriData[kategoriKey]?.data;
    if (list == null) return;

    final index = list.indexWhere((k) => k.idKeluhan == updated.idKeluhan);
    if (index != -1) {
      setState(() {
        list[index] = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Keluhan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF5B913B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<KeluhanResponse?>(
        future: _futureKeluhan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || _kategoriData.isEmpty) {
            return const Center(child: Text("Gagal memuat data keluhan."));
          }

          final kategoriKeys = _kategoriData.keys.toList();
          final selectedKey = _selectedKategori ?? kategoriKeys.first;
          final selectedKeluhanList = _kategoriData[selectedKey]?.data ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Pilih Kategori Keluhan",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedKey,
                  items: kategoriKeys.map((kategori) {
                    return DropdownMenuItem(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: selectedKeluhanList.isEmpty
                    ? const Center(child: Text("Tidak ada keluhan pada kategori ini."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: selectedKeluhanList.length,
                        itemBuilder: (context, index) {
                          final keluhan = selectedKeluhanList[index];

                          return Card(
                            color: Color(keluhan.statusColorValue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                keluhan.kategori.isNotEmpty ? keluhan.kategori : 'Tanpa Kategori',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    keluhan.masukan.isNotEmpty ? keluhan.masukan : 'Tidak ada masukan.',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pelapor: ${keluhan.namaPelapor.isNotEmpty ? keluhan.namaPelapor : 'Tidak diketahui'}',
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    keluhan.statusLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: keluhan.statusLabel.toLowerCase().contains('sudah')
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                final updatedKeluhan = await showModalBottomSheet<KeluhanItem>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (_) => KeluhanDetail(
                                    keluhan: keluhan,
                                    onUpdate: (updated) {
                                      Navigator.pop(context, updated);
                                    },
                                  ),
                                );

                                if (updatedKeluhan != null) {
                                  _updateKeluhanInList(updatedKeluhan);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
