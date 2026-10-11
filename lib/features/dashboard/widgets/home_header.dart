import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Top bar and user greeting matching the reference screenshot:
/// - Hamburger icon
/// - SolarCare logo with sun/solar icon in center
/// - User profile avatar
/// - "Good morning, \n Ravi Kumar"
/// - "Chennai, Tamil Nadu" location with house icon
class HomeHeader extends StatelessWidget {
  final String userName;
  final String location;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onQrScanTap;

  const HomeHeader({
    super.key,
    this.userName = 'Ravi Kumar',
    this.location = 'Chennai, Tamil Nadu',
    this.onMenuTap,
    this.onProfileTap,
    this.onQrScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top App Bar row: [Menu] [SolarCare Logo] [QR Scan + Avatar]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hamburger menu button
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(
                Icons.menu_rounded,
                size: 26,
                color: AppColors.textPrimary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            // Centered SolarCare Brand Logo
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SolarCareIcon(),
                const SizedBox(width: 8),
                const Text(
                  'SolarCare',
                  style: TextStyle(
                    color: AppColors.primaryEmerald,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),

            // QR Code Scan & User Profile Avatar Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onQrScanTap,
                  tooltip: 'Scan Inverter QR Code',
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 20,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mint, width: 1.5),
                      color: const Color(0xFFD1E7DD),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person_rounded,
                            size: 22,
                            color: AppColors.primaryEmerald,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Greeting text: "Good morning,"
        const Text(
          'Good morning,',
          style: TextStyle(
            color: Color(0xFF4A5E54),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),

        // User name: "Ravi Kumar"
        Text(
          userName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Location line: Home outline + "Chennai, Tamil Nadu"
        Row(
          children: [
            const Icon(
              Icons.home_outlined,
              size: 18,
              color: AppColors.primaryEmerald,
            ),
            const SizedBox(width: 6),
            Text(
              location,
              style: const TextStyle(
                color: Color(0xFF4C6156),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom drawn or layered SolarCare brand logo icon with sun and solar grid rays
class _SolarCareIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sun burst rays
          const Icon(
            Icons.wb_sunny_rounded,
            size: 26,
            color: Color(0xFF16935B),
          ),
          // Inner solar cells overlay
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              size: 11,
              color: AppColors.primaryEmerald,
            ),
          ),
        ],
      ),
    );
  }
}
