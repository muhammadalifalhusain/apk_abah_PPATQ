import 'package:flutter/material.dart';
import '../../services/keluhan_service.dart';
import '../../models/keluhan_model.dart';

class KeluhanDetail extends StatefulWidget {
  final KeluhanItem keluhan;
  final void Function(KeluhanItem)? onUpdate;

  const KeluhanDetail({
    super.key,
    required this.keluhan,
    this.onUpdate,
  });

  @override
  State<KeluhanDetail> createState() => _KeluhanDetailState();
}

class _KeluhanDetailState extends State<KeluhanDetail> {
  final KeluhanService _service = KeluhanService();
  late KeluhanItem _keluhan;

  @override
  void initState() {
    super.initState();
    _keluhan = widget.keluhan;
  }

  void _showReplyForm(BuildContext context) {
    final TextEditingController _replyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text('Balas Keluhan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _replyController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tulis balasan di sini...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Pesan tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.send),
                      label: const Text('Kirim Balasan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setModalState(() => _isLoading = true);
                                final result = await _service.submitReplyKeluhan(
                                  ReplyKeluhanRequest(
                                    idKeluhan: _keluhan.idKeluhan,
                                    pesan: _replyController.text.trim(),
                                  ),
                                );
                                setModalState(() => _isLoading = false);

                                if (result != null) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(result.message),
                                    backgroundColor: result.status == 201 ? Colors.green : Colors.orange,
                                  ));

                                  if (result.status == 201) {
                                    setState(() {
                                      _keluhan = _keluhan.copyWith(
                                        balasan: _replyController.text.trim(),
                                      );
                                    });

                                    widget.onUpdate?.call(_keluhan);
                                  }
                                }
                              }
                            },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showUpdateStatusForm(BuildContext context) {
    final TextEditingController _statusReplyController =
        TextEditingController(text: _keluhan.balasan);
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(builder: (context, setModalState) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tandai Sebagai Ditangani',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _statusReplyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Edit balasan jika perlu...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Pesan tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Tandai Ditangani'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setModalState(() => _isLoading = true);
                              final result = await _service.updateReplyKeluhan(
                                idKeluhan: _keluhan.idKeluhan,
                                status: 2,
                                pesan: _statusReplyController.text.trim(),
                              );
                              setModalState(() => _isLoading = false);

                              if (result != null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(result.message),
                                  backgroundColor: result.status == 200 ? Colors.green : Colors.orange,
                                ));

                                if (result.status == 200) {
                                  setState(() {
                                    _keluhan = _keluhan.copyWith(
                                    status: '2',
                                  );

                                  });

                                  widget.onUpdate?.call(_keluhan);
                                }
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              _keluhan.kategori.isNotEmpty ? _keluhan.kategori : "Kategori",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text("Status: ${_keluhan.statusLabel}"),
                if (_keluhan.status == '1' && _keluhan.balasan.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Menunggu Validasi",
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            Text("Masukan:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(_keluhan.masukan.isNotEmpty ? _keluhan.masukan : '-'),
            const SizedBox(height: 12),
            Text("Saran:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(_keluhan.saran.isNotEmpty ? _keluhan.saran : '-'),
            const SizedBox(height: 12),
            Text("Rating: ${_keluhan.rating}/10"),
            const SizedBox(height: 20),

            if (_keluhan.balasan.isEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.reply, size: 28, color: Colors.teal),
                  tooltip: "Balas Keluhan",
                  onPressed: () => _showReplyForm(context),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 32),
                  const Text("Balasan:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_keluhan.balasan),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.verified, color: Colors.green, size: 28),
                      tooltip: "Tandai sebagai ditangani",
                      onPressed: _keluhan.status == '2' ? null : () => _showUpdateStatusForm(context),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
