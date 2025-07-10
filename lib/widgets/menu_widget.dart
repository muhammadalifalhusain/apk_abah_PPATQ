import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/main/kurban_screen.dart';
import '../screens/main/belum_lapor_screen.dart';
import '../screens/main/bayar_bulan_lalu_screen.dart';
import '../screens/main/kamar_screen.dart';

class MenuIkonWidget extends StatefulWidget {
  const MenuIkonWidget({Key? key}) : super(key: key);

  @override
  State<MenuIkonWidget> createState() => _MenuIkonWidgetState();
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

class _MenuIkonWidgetState extends State<MenuIkonWidget> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);
    final displayedItems = _showAll ? menuItems : menuItems.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.dashboard_customize_rounded, color: Colors.grey, size: 20),
              const SizedBox(width: 6),
              Text(
                'Menu Cepat',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          children: displayedItems.map((item) => _buildMenuItem(context, item)).toList(),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            icon: Icon(_showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            label: Text(_showAll ? 'Tutup' : 'Lainnya'),
          ),
        ),
      ],
    );
  }

  List<_MenuItem> _buildMenuItems(BuildContext context) {
    return [
      _MenuItem(
        icon: Icons.report_rounded,
        label: 'Belum Lapor',
        color: const Color(0xFFE91E63),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BelumLaporScreen()));
        },
      ),
      _MenuItem(
        icon: Icons.verified_user_rounded,
        label: 'Bayar Valid',
        color: const Color(0xFF9C27B0),
        onTap: () {
          _showComingSoonDialog(context, 'Bayar Valid');
        },
      ),
      _MenuItem(
        icon: Icons.history_rounded,
        label: 'Bayar Lalu',
        color: const Color(0xFF607D8B),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BayarBulanLaluScreen()));
        },
      ),
      _MenuItem(
        icon: Icons.bed_rounded,
        label: 'Kamar',
        color: const Color(0xFF3F51B5),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const KamarScreen()));
        },
      ),
      _MenuItem(
        icon: Icons.class_rounded,
        label: 'Kelas',
        color: const Color(0xFF00BCD4),
        onTap: () {
          _showComingSoonDialog(context, 'Kelas');
        },
      ),
      _MenuItem(
        icon: Icons.menu_book_rounded,
        label: 'Tahfidz',
        color: const Color(0xFF795548),
        onTap: () {
          _showComingSoonDialog(context, 'Tahfidz');
        },
      ),
      _MenuItem(
        icon: Icons.warehouse_rounded,
        label: 'Aset',
        color: const Color(0xFF8BC34A),
        onTap: () {
          _showComingSoonDialog(context, 'Aset');
        },
      ),
      _MenuItem(
        icon: Icons.local_fire_department_rounded,
        label: 'Kurban',
        color: const Color(0xFFCDDC39),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const KurbanScreen()));
        },
      ),
    ];
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Info', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Fitur $feature sedang dalam pengembangan dan akan segera tersedia.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Mengerti', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
