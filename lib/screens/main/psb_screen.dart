import 'package:flutter/material.dart';
import '../../models/psb_model.dart';
import '../../services/psb_service.dart';

class PsbScreen extends StatefulWidget {
  const PsbScreen({super.key});

  @override
  State<PsbScreen> createState() => _PsbScreenState();
}

class _PsbScreenState extends State<PsbScreen> {
  final PsbService _psbService = PsbService();
  List<PsbData> _psbList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPsb();
  }

  Future<void> fetchPsb() async {
    final data = await _psbService.fetchPsbData();
    setState(() {
      _psbList = data;
      _isLoading = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data PSB'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _psbList.isEmpty
              ? const Center(child: Text('Belum ada data PSB'))
              : RefreshIndicator(
                  onRefresh: fetchPsb,
                  child: ListView.builder(
                    itemCount: _psbList.length,
                    itemBuilder: (context, index) {
                      return _buildPsbItem(_psbList[index]);
                    },
                  ),
                ),
    );
  }
}
