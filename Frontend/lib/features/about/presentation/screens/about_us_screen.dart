import 'package:flutter/material.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E7EB), height: 1),
        ),
        leading: Builder(
          builder: (context) => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: Color(0xFF4A5565), size: 24),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 20,
            color: Color(0xFF4A5565),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // App Header Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A5869), Color(0xFF00B8D0)], // Dark grayish blue to Cyan
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.1, 1.0],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('🏪', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontFamily: 'Arimo', fontSize: 24, color: Colors.white),
                        children: [
                          TextSpan(text: 'Point'),
                          TextSpan(text: 'Sale', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Our App section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Our App',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'PointSale is a powerful point-of-sale system designed to simplify sales, inventory, and customer management. Whether you run a small store or a growing business, our app provides the tools you need to succeed.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Features section label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'FEATURES',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            _buildFeatureItem(
              icon: Icons.bolt_outlined, // Lightning bolt Outline
              title: 'Fast & Efficient',
              desc: 'Lightning-fast checkout and inventory management',
            ),
            _buildFeatureItem(
              icon: Icons.shield_outlined, // Shield outline
              title: 'Secure',
              desc: 'Bank-level security for your business data',
            ),
            _buildFeatureItem(
              icon: Icons.favorite_border, // Heart border
              title: 'Easy to Use',
              desc: 'Intuitive interface designed for everyone',
            ),
            
            const SizedBox(height: 24),
            
            // Contact Us section label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'CONTACT US',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Contact Us block
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildContactItem(icon: Icons.email_outlined, title: 'Email', value: 'support@posapp.com'),
                  const Divider(height: 1, indent: 64),
                  _buildContactItem(icon: Icons.phone_outlined, title: 'Phone', value: '+1 (555) 123-4567'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Follow Us section label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'FOLLOW US',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildSocialButton(icon: Icons.facebook, label: 'Facebook'),
                  const SizedBox(width: 8),
                  _buildSocialButton(icon: Icons.telegram, label: 'Telegram'),
                  const SizedBox(width: 8),
                  _buildSocialButton(icon: Icons.business, label: 'LinkedIn'),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Footer section
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Privacy Policy', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(' • ', style: TextStyle(color: Color(0xFF6B7280))),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Terms of Service', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('© 2025 POS Mobile App. All rights reserved.', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA).withOpacity(0.5), // match figma blue-ish tint
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00B8D0), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // light gray background for contact icons
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4B5563), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF6B7280)),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Color(0xFF111827), fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF4B5563)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
