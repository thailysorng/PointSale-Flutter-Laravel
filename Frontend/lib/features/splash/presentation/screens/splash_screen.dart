import 'package:flutter/material.dart';
import 'package:point_sale/features/auth/presentation/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  Future<void> _navigateToSignIn() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00D492), 
              Color(0xFF00D5BE), 
              Color(0xFF00B8DB), 
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStoreIcon(),

                    const SizedBox(height: 40),
                    _buildTitle(),

                    const SizedBox(height: 40),
                    _buildPageIndicators(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreIcon() {
    return SizedBox(
      width: 160,
      height: 192,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 160,
              height: 180,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset('assets/images/icons/store_icon.png', fit: BoxFit.contain,),
              ),
            ),
          ),
          Positioned(
            left: -27,
            bottom: 27,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                    spreadRadius: -3,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 24,
                color: Color(0xFF00D492),
              ),
            ),
          ),

          Positioned(
            right: -27,
            top: 27,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                    spreadRadius: -3,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.trending_up,
                size: 24,
                color: Color(0xFF00D492),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 36,
              height: 1.11, 
              letterSpacing: -0.9,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'Point',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'Sale',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Manage Your Business,',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 18,
            height: 1.56, 
            color: Color(0xE6FFFFFF), 
          ),
        ),
        Text(
          'With Ease',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 18,
            height: 1.56,
            color: Color(0xE6FFFFFF),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
