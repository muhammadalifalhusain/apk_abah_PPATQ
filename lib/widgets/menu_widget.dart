import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/main/psb_screen.dart';

class MenuIkonWidget extends StatefulWidget {
  const MenuIkonWidget({Key? key}) : super(key: key);

  @override
  State<MenuIkonWidget> createState() => _MenuIkonWidgetState();
}

class _MenuIkonWidgetState extends State<MenuIkonWidget> {
  bool _showAll = false;

  final List<_MenuItem> _allMenuItems = [
    _MenuItem(icon: Icons.group_add_rounded, label: 'PSB', color: Color(0xFF4CAF50), onTap: PsbScreen()),
    _MenuItem(icon: Icons.school_rounded, label: 'Santri', color: Color(0xFF2196F3)),
    _MenuItem(icon: Icons.badge_rounded, label: 'Pegawai', color: Color(0xFFFF9800)),
    _MenuItem(icon: Icons.report_rounded, label: 'Belum Lapor', color: Color(0xFFE91E63)),
    _MenuItem(icon: Icons.verified_user_rounded, label: 'Bayar Valid', color: Color(0xFF9C27B0)),
    _MenuItem(icon: Icons.history_rounded, label: 'Bayar Lalu', color: Color(0xFF607D8B)),
    _MenuItem(icon: Icons.bed_rounded, label: 'Kamar', color: Color(0xFF3F51B5)),
    _MenuItem(icon: Icons.class_rounded, label: 'Kelas', color: Color(0xFF00BCD4)),
    _MenuItem(icon: Icons.menu_book_rounded, label: 'Tahfidz', color: Color(0xFF795548)),
    _MenuItem(icon: Icons.warehouse_rounded, label: 'Aset', color: Color(0xFF8BC34A)),
    _MenuItem(icon: Icons.supervised_user_circle_rounded, label: 'Murroby', color: Color(0xFFFF5722)),
    _MenuItem(icon: Icons.account_circle_rounded, label: 'Ustad', color: Color(0xFF673AB7)),
    _MenuItem(icon: Icons.local_fire_department_rounded, label: 'Kurban', color: Color(0xFFCDDC39)),
  ];

  @override
  Widget build(BuildContext context) {
    final displayedItems = _showAll ? _allMenuItems : _allMenuItems.take(6).toList();

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

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: () {
        if (item.onTap != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.onTap!),
          );
        } else {
          _showComingSoonDialog(context, item.label);
        }
      },
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
                style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold),
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

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget? onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}
