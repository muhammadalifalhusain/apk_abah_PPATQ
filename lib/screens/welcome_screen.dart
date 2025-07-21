import 'package:abah/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'galeri_screen.dart'; 
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.85);
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
  void _handleMenuTap(String menuLabel) {
    // Feedback haptic
    HapticFeedback.lightImpact();
    
    // Animasi tekan
    setState(() {
      _lastPressedMenu = menuLabel;
    });
    
    // Navigasi berdasarkan menu yang dipilih
    switch(menuLabel) {
      case 'Informasi Dakwah':
        // Navigator.push(context, MaterialPageRoute(builder: (_) => DakwahScreen()));
        _showComingSoonSnackbar();
        break;
      case 'Informasi':
        // Navigator.push(context, MaterialPageRoute(builder: (_) => InfoScreen()));
        _showComingSoonSnackbar();
        break;
      case 'Tentang Pesantren':
        // Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
        _showComingSoonSnackbar();
        break;
      case 'Galeri':
        Navigator.push(context, MaterialPageRoute(builder: (_) => GaleriScreen()));
        break;
      case 'Lokasi':
        // Navigator.push(context, MaterialPageRoute(builder: (_) => LocationScreen()));
        _showComingSoonSnackbar();
        break;
    }
  }

  void _showComingSoonSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur ini akan segera hadir', 
          style: GoogleFonts.poppins()),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color iconColor) {
    final isPressed = _lastPressedMenu == label;
    
    return Padding(
      padding: const EdgeInsets.all(4),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isPressed ? 0.95 : 1.0,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleMenuTap(label),
            splashColor: Colors.white.withOpacity(0.2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCustomIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: menuPages.length,
      effect: ExpandingDotsEffect(
        activeDotColor: Colors.teal.shade400,
        dotColor: Colors.white.withOpacity(0.4),
        dotHeight: 6,
        dotWidth: 6,
        expansionFactor: 3,
        spacing: 4,
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
              decoration: BoxDecoration(
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
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Main content
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          
                          child: Column(
                            children: [
                              Text(
                                'RAUDLATUL FALAH - PATI',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 25),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(125),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(125),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 220, 
                        height: 220,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.withOpacity(0.15),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 85, 
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: menuPages.length,
                          onPageChanged: (index) => setState(() => _currentPage = index),
                          itemBuilder: (context, pageIndex) {
                            return GridView.count(
                              physics: const NeverScrollableScrollPhysics(), 
                              crossAxisCount: 3, 
                              childAspectRatio: 0.8, 
                              shrinkWrap: true,
                              children: menuPages[pageIndex]
                                  .map((item) => _buildMenuItem(
                                        item['icon'],
                                        item['label'],
                                        item['color'],
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCustomIndicator(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginAbahScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.login,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'MASUK',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
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
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}