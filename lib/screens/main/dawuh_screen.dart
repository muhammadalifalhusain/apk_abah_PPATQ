import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; 
import '../../services/dawuh_service.dart';
import '../../models/dawuh_model.dart';

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
        title: const Text('Daftar Dawuh'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<DawuhAbah>>(
          future: _dawuhFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data dawuh'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final dawuh = snapshot.data![index];
                  return _buildDawuhCard(dawuh);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDawuhDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDawuhCard(DawuhAbah dawuh) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dawuh.foto.isNotEmpty)
              Image.network(
                'https://api.ppatq-rf.id/assets/upload/dawuh-abah/${dawuh.foto}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.broken_image, size: 100),
              ),
            const SizedBox(height: 12),
            Text(
              dawuh.judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(dawuh.isiDakwah),
          ],
        ),
      ),
    );
  }

  void _showAddDawuhDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDawuhDialog(
        onSubmitted: () {
          _refreshData(); // Refresh data setelah submit
          Navigator.pop(context);
        },
      ),
    );
  }
}

class AddDawuhDialog extends StatefulWidget {
  final VoidCallback onSubmitted;

  const AddDawuhDialog({required this.onSubmitted, Key? key}) : super(key: key);

  @override
  _AddDawuhDialogState createState() => _AddDawuhDialogState();
}

class _AddDawuhDialogState extends State<AddDawuhDialog> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiDakwahController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitDawuh() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field dan pilih gambar')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = DawuhRequest(
        judul: _judulController.text,
        isiDakwah: _isiDakwahController.text,
        foto: _selectedImage!,
      );

      final response = await DawuhService().createDawuh(request);

      if (response.status == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        widget.onSubmitted();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiDakwahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Dawuh Baru'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Judul wajib diisi' : null,
              ),
              TextFormField(
                controller: _isiDakwahController,
                decoration: const InputDecoration(labelText: 'Isi Dakwah'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Isi dakwah wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150)
                  : const Text('Belum ada gambar dipilih'),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pilih Gambar'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitDawuh,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Simpan'),
        ),
      ],
    );
  }
}