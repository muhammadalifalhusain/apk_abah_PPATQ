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
import '../screens/main/keuangan_screen.dart';
import '../screens/main/pelanggaran_screen.dart';
import '../screens/main/kelengkapan_screen.dart';
import '../screens/main/kesehatan_screen.dart';

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
    final displayedItems = _showAll ? filteredItems : filteredItems.take(8).toList();
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
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 4,
          mainAxisSpacing: 11,
          children: displayedItems.map((item) => _buildMenuItem(context, item)).toList(),
        ),

        const SizedBox(height: 10),
        if (filteredItems.length > 8)
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
        label: 'Kemurobbyan',
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
        label: 'Pelanggaran',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PelanggaranScreen())),
      ),
      _MenuItem(
        icon: Icons.security_rounded,
        label: 'Kelengkapan',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KelengkapanScreen())),
      ),
      _MenuItem(
        icon: Icons.health_and_safety,
        label: 'Kesehatan',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KesehatanScreen())),
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
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KurbanSummaryScreen())),
      ),
      _MenuItem(
        icon: Icons.inventory_2_rounded,
        label: 'Aset',
        color: Colors.lightGreen,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AsetScreen())),
      ),
      _MenuItem(
        icon: Icons.event,
        label: 'Agenda',
        color: Colors.lime,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgendaScreen())),
      ),
      _MenuItem(
        icon: Icons.history_edu,
        label: 'Alumni',
        color: Colors.teal,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlumniScreen())),
      ),
    ];
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 40),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
