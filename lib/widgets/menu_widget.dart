import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/main/kurban_screen.dart';
import '../screens/main/kamar_screen.dart';
import '../screens/main/aset_screen.dart';
import '../screens/main/dawuh_screen.dart';
import '../screens/main/keluhan_screen.dart';
import '../screens/main/tahfidz_screen.dart';
import '../screens/main/pegawai_screen.dart';
import '../screens/main/agenda_screen.dart';
import '../screens/main/alumni_screen.dart';
import '../screens/main/psb_screen.dart';
import '../screens/main/santri_screen.dart';
import '../screens/main/kelas_screen.dart';
import '../screens/main/keuangan_screen.dart';

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
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allItems = _buildMenuItems(context);
    final filteredItems = allItems
        .where((item) =>
            item.label.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final displayedItems = _showAll ? filteredItems : filteredItems.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.grid_view_rounded, color: Colors.grey, size: 20),
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
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              hintText: 'Cari menu...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
        if (filteredItems.length > 6)
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
        icon: Icons.assignment_ind_rounded,
        label: 'PSB',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PsbScreen())),
      ),
      _MenuItem(
        icon: Icons.groups_rounded,
        label: 'Santri',
        color: Colors.brown,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SantriScreen())),
      ),
      _MenuItem(
        icon: Icons.badge_rounded,
        label: 'Staff',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiScreen())),
      ),
      _MenuItem(
        icon: Icons.bedroom_child_rounded,
        label: 'Kemurobbian',
        color: Colors.deepPurpleAccent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KamarScreen())),
      ),
      _MenuItem(
        icon: Icons.auto_stories_rounded,
        label: 'Ketahfidzan',
        color: Colors.brown,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TahfidzScreen())),
      ),
      _MenuItem(
        icon: Icons.security_rounded,
        label: 'Keamanan',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiScreen())),
      ),
      _MenuItem(
        icon: Icons.security_rounded,
        label: 'Kelengkapan',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KelasScreen())),
      ),
      _MenuItem(
        icon: Icons.health_and_safety,
        label: 'Kesehatan',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiScreen())),
      ),
      _MenuItem(
        icon: Icons.health_and_safety,
        label: 'Ketertiban',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiScreen())),
      ),
      _MenuItem(
        icon: Icons.record_voice_over_rounded,
        label: 'Dawuh',
        color: Colors.indigo,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DawuhScreen())),
      ),
      _MenuItem(
        icon: Icons.money_outlined,
        label: 'Keuangan',
        color: Colors.indigo,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KeuanganScreen())),
      ),
      _MenuItem(
        icon: Icons.report_problem_rounded,
        label: 'Saran&Kritik',
        color: Colors.red,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KeluhanScreen())),
      ), 
      _MenuItem(
        icon: Icons.volunteer_activism_rounded,
        label: 'Qurban',
        color: Colors.lime,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KurbanScreen())),
      ),
      _MenuItem(
        icon: Icons.inventory_2_rounded,
        label: 'Aset',
        color: Colors.lightGreen,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AsetScreen())),
      ),
      _MenuItem(
        icon: Icons.volunteer_activism_rounded,
        label: 'Agenda',
        color: Colors.lime,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgendaScreen())),
      ),
      _MenuItem(
        icon: Icons.history_edu_rounded,
        label: 'Alumni',
        color: Colors.teal,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlumniScreen())),
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
}
