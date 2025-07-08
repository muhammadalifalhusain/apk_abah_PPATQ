import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_model.dart';
import '../../services/dashboard_service.dart';
import '../../services/login_service.dart';
import '../login_screen.dart';
import '../../widgets/menu_widget.dart';
import 'pegawai_screen.dart';
import 'belum_lapor_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  DashboardData? _dashboardData;
  bool _isLoading = true;

  String? nama;
  String? photo;

  @override
  void initState() {
    super.initState();
    loadUserSession();
    loadDashboard();
  }

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPhoto = prefs.getString('photo') ?? '';

    setState(() {
      nama = prefs.getString('nama') ?? 'Pengguna';
      photo = storedPhoto.isNotEmpty
          ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/$storedPhoto'
          : ''; // Kosong jika tidak tersedia
    });
  }

  Future<void> loadDashboard() async {
    final data = await _dashboardService.fetchDashboard();
    setState(() {
      _dashboardData = data;
      _isLoading = false;
    });
  }

  Future<void> handleLogout() async {
    final result = await LoginService.logout();
    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginAbah()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Logout gagal')),
      );
    }
  }

  Widget _buildStatGroupCard(List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          return Expanded(
            child: GestureDetector(
              onTap: item['onTap'],
              child: Column(
                children: [
                  Icon(item['icon'], color: item['color'], size: 20),
                  const SizedBox(height: 6),
                  Text(
                    item['value'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'],
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: (photo != null && photo!.isNotEmpty)
                      ? NetworkImage(photo!)
                      : const AssetImage('assets/images/logo.png') as ImageProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang,',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      nama ?? 'User',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        handleLogout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Dashboard Abah',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dashboardData == null
              ? const Center(child: Text('Gagal memuat data dashboard'))
              : RefreshIndicator(
                  onRefresh: () async {
                    await loadUserSession();
                    await loadDashboard();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 10),
                        MenuIkonWidget(),
                        const SizedBox(height: 8),
                        // Santri Section
                        _buildSectionTitle('Data Santri', Icons.school),
                        const SizedBox(height: 12),
                        _buildStatGroupCard([
                          {
                            'label': 'Total',
                            'value': _dashboardData!.jumlahSantri,
                            'icon': Icons.groups,
                            'color': Colors.green,
                          },
                          {
                            'label': 'Laki-laki',
                            'value': _dashboardData!.jumlahSantriLaki,
                            'icon': Icons.male,
                            'color': Colors.blue,
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahSantriPerempuan,
                            'icon': Icons.female,
                            'color': Colors.pink,
                          },
                          {
                            'label': 'Belum Lapor',
                            'value': _dashboardData!.jumlahSantriBelumLapor,
                            'icon': Icons.warning_amber,
                            'color': Colors.orange,
                            'onTap': () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const BelumLaporScreen()));
                            }
                          },
                        ]),
                        const SizedBox(height: 5),
                        
                        // Pegawai Section
                        _buildSectionTitle('Data Pegawai', Icons.people),
                        const SizedBox(height: 12),
                        _buildStatGroupCard([
                          {
                            'label': 'Total',
                            'value': _dashboardData!.jumlahPegawai,
                            'icon': Icons.groups,
                            'color': Colors.purple,
                            'onTap': () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiScreen()));
                            }
                          },
                          {
                            'label': 'Laki-laki',
                            'value': _dashboardData!.jumlahPegawaiLaki,
                            'icon': Icons.male,
                            'color': Colors.blue,
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahPegawaiPerempuan,
                            'icon': Icons.female,
                            'color': Colors.pink,
                          },
                        ]),
                        const SizedBox(height: 5),
                        _buildSectionTitle('Data PSB', Icons.app_registration),
                        const SizedBox(height: 12),
                        _buildStatGroupCard([
                          {
                            'label': 'Tahun Ini',
                            'value': _dashboardData!.jumlahPsb,
                            'icon': Icons.app_registration,
                            'color': Colors.teal,
                          },
                          {
                            'label': 'Laki-laki',
                            'value': _dashboardData!.jumlahPsbLaki,
                            'icon': Icons.male,
                            'color': Colors.blue,
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahPsbPerempuan,
                            'icon': Icons.female,
                            'color': Colors.pink,
                          },
                          {
                            'label': 'Tahun Lalu',
                            'value': _dashboardData!.jumlahPsbTahunLalu,
                            'icon': Icons.history,
                            'color': Colors.grey,
                          },
                        ]),
                        const SizedBox(height: 15),
                        
                        // Pembayaran Section
                        _buildSectionTitle('Data Pembayaran', Icons.payments),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _buildLargeStatCard('Jumlah', _dashboardData!.jumlahPembayaran.toString(), Icons.receipt, Colors.red),
                            const SizedBox(height: 12),
                            _buildLargeStatCard('Total', _formatCurrency(_dashboardData!.totalPembayaran), Icons.money, Colors.green),
                            const SizedBox(height: 12),
                            _buildLargeStatCard('Tahun Lalu', _formatCurrency(_dashboardData!.jumlahPembayaranLalu), Icons.history, Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildLargeStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(String nominal) {
    try {
      final number = int.tryParse(nominal) ?? 0;
      return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    } catch (_) {
      return 'Rp 0';
    }
  }
}