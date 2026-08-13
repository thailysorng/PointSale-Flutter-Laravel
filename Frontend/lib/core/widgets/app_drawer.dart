import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/app_color.dart';
import 'package:point_sale/app/app_routes.dart';
import 'package:point_sale/core/services/user_session.dart';
import 'package:point_sale/features/auth/data/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current route
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final user = UserSession.instance.user;

    return Drawer(
      child: Column(
        children: [
          // Header Section with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColor.textSecondary, AppColor.primary],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 20,
                          color: AppColor.whiteWithOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        icon: Icon(
                          Icons.close,
                          color: AppColor.whiteWithOpacity(0.9),
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // User Profile Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.whiteWithOpacity(0.7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColor.whiteWithOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColor.textSecondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user != null ? user['name'] ?? 'User' : 'User'}',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 16,
                                  color: AppColor.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                '${user != null ? user['email'] ?? 'Email' : 'Email'}',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: AppColor.textSecondary,
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'NAVIGATION',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 12,
                      color: AppColor.textSecondary,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: currentRoute == '/',
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_cart,
                  label: 'Checkout',
                  isActive: currentRoute == '/checkout',
                  onTap: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long,
                  label: 'Orders',
                  isActive: currentRoute == '/orders',
                  onTap: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2,
                  label: 'Products',
                  isActive: currentRoute == '/products',
                  onTap: () {
                    Navigator.pushNamed(context, '/products');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory,
                  label: 'Stock Management',
                  isActive: currentRoute == '/stock',
                  onTap: () {
                    Navigator.pushNamed(context, '/stock');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.swap_horiz,
                  label: 'Transactions',
                  isActive: currentRoute == '/transactions',
                  onTap: () {
                    Navigator.pushNamed(context, '/transactions');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  label: 'Analytics',
                  isActive: currentRoute == '/analytics',
                  onTap: () {
                    Navigator.pushNamed(context, '/analytics');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  isActive: currentRoute == '/settings',
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info,
                  label: 'About Us',
                  isActive:
                      false, // User requested same style as Settings, effectively disabling the active state highlight
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),

          // Sign Out Button
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColor.whiteWithOpacity(0.9),
                  width: 1.15,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
            child: InkWell(
              onTap: () async {
                await AuthService().logout();

                if (!context.mounted) {
                  return;
                }

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signin,
                  (route) => false,
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColor.error, size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: AppColor.error,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColor.primary.withOpacity(0.16)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, size: 20, color: AppColor.textSecondary),
        title: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arimo',
            fontSize: 16,
            color: AppColor.textSecondary,
            height: 1.5,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 16,
          color: AppColor.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
