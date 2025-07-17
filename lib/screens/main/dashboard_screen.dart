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
import 'psb_screen.dart';
import 'santri_screen.dart';
import 'berita_screen.dart';
import '../../models/berita_model.dart';
import '../../services/berita_service.dart';
import '../../utils/get_month.dart';

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
  List<BeritaItem> _beritaList = [];
  bool _isLoadingBerita = false;
  int _beritaPage = 1;


  @override
  void initState() {
    super.initState();
    loadUserSession();
    loadDashboard();
    loadBerita(); 
  }

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPhoto = prefs.getString('photo') ?? '';

    setState(() {
      nama = prefs.getString('nama') ?? 'Pengguna';
      photo = storedPhoto.isNotEmpty
          ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/$storedPhoto'
          : ''; 
    });
  }

  Future<void> loadBerita() async {
    if (_isLoadingBerita) return;
    setState(() => _isLoadingBerita = true);

    final res = await BeritaService.fetchBerita(page: _beritaPage);
    if (res != null) {
      setState(() {
        _beritaList.addAll(res.data.data);
        _beritaPage++;
      });
    }

    setState(() => _isLoadingBerita = false);
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
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                mainAxisSize: MainAxisSize.min,
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
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
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
          color: const Color.fromARGB(255, 56, 96, 31), 
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
                      child: const Text('Keluar'),
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
        backgroundColor: const Color(0xFF5B913B), 
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'V 1.1.2',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
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
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _buildCombinedStatsCard(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        MenuIkonWidget(),
                        _buildSectionTitle('Data Santri', Icons.school),
                        _buildStatGroupCard([
                          {
                            'label': 'Total',
                            'value': _dashboardData!.jumlahSantri,
                            'icon': Icons.groups,
                            'color': Colors.green,
                            'onTap': () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SantriScreen()));
                            }
                          },
                          {
                            'label': 'Laki-laki',
                            'value': _dashboardData!.jumlahSantriLaki,
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahSantriPerempuan,
                          },
                          {
                            'label': 'Tidak Melapor',
                            'value': _dashboardData!.jumlahSantriBelumLapor,
                            'icon': Icons.warning_amber,
                            'color': Colors.orange,
                            'onTap': () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const BelumLaporScreen()));
                            }
                          },
                        ]),
                        _buildSectionTitle('Data Pegawai', Icons.people),
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
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahPegawaiPerempuan,
                          },
                        ]),
                        if ((_dashboardData?.tahfidzan.highest?.students.isNotEmpty ?? false) ||
                          (_dashboardData?.tahfidzan.lowest?.students.isNotEmpty ?? false)) ...[
                          _buildSectionTitle('Ketahfidzan Santri', Icons.menu_book_rounded),
                          const SizedBox(height: 4),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: const Text('Lihat Detail Capaian'),
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              children: [
                                if (_dashboardData!.tahfidzan.highest?.students.isNotEmpty == true) ...[
                                  Text(
                                    'Capaian Tertinggi: ${_dashboardData!.tahfidzan.highest?.achievement.isNotEmpty == true ? _dashboardData!.tahfidzan.highest!.achievement : "-"}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildSantriGrid(_dashboardData!.tahfidzan.highest!.students),
                                  const SizedBox(height: 16),
                                ],
                                if (_dashboardData!.tahfidzan.lowest?.students.isNotEmpty == true) ...[
                                  Text(
                                    'Capaian Terendah: ${_dashboardData!.tahfidzan.lowest?.achievement.isNotEmpty == true ? _dashboardData!.tahfidzan.lowest!.achievement : "-"}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildSantriGrid(_dashboardData!.tahfidzan.lowest!.students),
                                ],
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        _buildSectionTitle('Data PSB', Icons.app_registration),
                        _buildStatGroupCard([
                          {
                            'label': 'Tahun Ini',
                            'value': _dashboardData!.jumlahPsb,
                            'icon': Icons.app_registration,
                            'color': Colors.teal,
                            'onTap': () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const PsbScreen()));
                            }
                          },
                          {
                            'label': 'Laki-laki',
                            'value': _dashboardData!.jumlahPsbLaki,
                          },
                          {
                            'label': 'Perempuan',
                            'value': _dashboardData!.jumlahPsbPerempuan,
                          },
                          {
                            'label': 'Tahun Lalu',
                            'value': _dashboardData!.jumlahPsbTahunLalu,
                          },
                        ]),
                        _beritaList.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Berita Terbaru', Icons.newspaper),
                              BeritaScreen(
                                beritaList: _beritaList,
                                onReachEnd: () {
                                  loadBerita();
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCombinedStatsCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resume Pembayaran',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Bulan ${_dashboardData?.bulanIni ?? '0'}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: "Laporan Bayar s/d tanggal ${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year}\n",
              style: TextStyle(fontSize: 14), 
              children: [
                TextSpan(
                  text: "Jumlah Lapor Bayar Rp : ${_dashboardData?.totalTagihanSyahriah ?? '0'}\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                TextSpan(
                  text: "Telah divalidasi Rp : ${_dashboardData?.totalPembayaranValidBulanIni ?? '0'}\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                TextSpan(
                  text: "Belum divalidasi Rp : ${_dashboardData?.totalPembayaranUnvalidBulanIni ?? '0'}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${_dashboardData?.jumlahSantriBelumLapor ?? '0'}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: ' Santri Belum melakukan pembayaran syahriah',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal, 
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildSantriGrid(List<Student> students) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final student = students[index];
        final hasPhoto = student.photo != null && student.photo!.isNotEmpty;
        final photoUrl = hasPhoto
            ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${student.photo}'
            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(student.name)}&background=0D8ABC&color=fff';

        return Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(height: 4),
            Text(
              student.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }



  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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