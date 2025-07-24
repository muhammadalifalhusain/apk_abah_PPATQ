import 'package:abah/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'galeri_screen.dart';
import 'dakwah_screen.dart';
import 'about_screen.dart';
import 'informasi_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _lastPressedMenu;

  final List<List<Map<String, dynamic>>> menuPages = [
    [
      {'icon': Icons.record_voice_over, 'label': 'Dawuh Abah', 'color': Colors.orange},
      {'icon': Icons.photo_library, 'label': 'Galeri', 'color': Colors.purple},
      {'icon': Icons.school, 'label': 'PPATQ-RF ku', 'color': Colors.green},
    ],
    [
      {'icon': Icons.info_outline, 'label': 'Informasi', 'color': Colors.blue},
      {'icon': Icons.location_on, 'label': 'Lokasi', 'color': Colors.red},
    ],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleMenuTap(String label) async {
    HapticFeedback.lightImpact();
    setState(() => _lastPressedMenu = label);

    switch (label) {
      case 'Dawuh Abah':
        Navigator.push(context, MaterialPageRoute(builder: (_) => DakwahScreen()));
        break;
      case 'Galeri':
        Navigator.push(context, MaterialPageRoute(builder: (_) => GaleriScreen()));
        break;
      case 'PPATQ-RF ku':
        Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
        break;
      case 'Lokasi':
        final url = Uri.parse('https://maps.app.goo.gl/MdLVEh8XRvam5ohc7');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tidak dapat membuka Google Maps")),
          );
        }
        break;
      case 'Informasi':
        Navigator.push(context, MaterialPageRoute(builder: (_) => InformasiScreen()));
        break;
      default:
        _showComingSoonSnackbar();
    }
  }

  void _showComingSoonSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur ini akan segera hadir', style: GoogleFonts.poppins()),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildMenuGrid(List<Map<String, dynamic>> menus) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menus.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 6,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final item = menus[index];
          final isPressed = _lastPressedMenu == item['label'];

          return AnimatedScale(
            scale: isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _handleMenuTap(item['label']),
                splashColor: Colors.white.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'], size: 27, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        menuPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 16 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg-welcome.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'RAUDLATUL FALAH - PATI',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'AKSES ABAH',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(125),
                  child: Image.asset('assets/images/logo.png', width: 180, height: 180),
                ),
                const SizedBox(height: 280),

                // Menu Area
                SizedBox(
                  height: 155,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: menuPages.length,
                    itemBuilder: (context, index) => _buildMenuGrid(menuPages[index]),
                  ),
                ),
                _buildPageIndicator(),
                const SizedBox(height: 10),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade400, Colors.teal.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginAbahScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'MASUK',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
