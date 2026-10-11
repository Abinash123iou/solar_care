import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/screens/sign_in_screen.dart';
import '../widgets/solar_leaf_logo.dart';

/// Screen 1 — Splash / Welcome Screen
/// Faithfully reproduces the SolarDiagnostics Splash / Welcome reference design:
/// - Soft sky-blue backdrop with realistic sunlit rooftop solar installation
/// - Centered green leaf logo, bold "SolarDiagnostics" title, and tagline
/// - Raised white bottom card with rounded corners and drag pill
/// - Emerald "Sign In" button and bordered "Create Account" button
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignInScreen(initialIsSignUp: false),
      ),
    );
  }

  void _navigateToCreateAccount(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignInScreen(initialIsSignUp: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F4),
      body: Stack(
        children: [
          // -----------------------------------------------------------
          // A & C. Full-screen background with soft sky and rooftop photo
          // -----------------------------------------------------------
          Positioned.fill(
            child: Column(
              children: [
                // Sky area with gradient blend
                Expanded(
                  flex: 11,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFD6EEF9), // Soft sky blue at top
                          Color(0xFFE8F4F8),
                          Color(0xFFF2F8F6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Realistic rooftop solar house image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/rooftop_solar_welcome.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackSolarBackdrop();
                            },
                          ),
                        ),

                        // Subtle gradient overlay to ensure perfect logo/text contrast
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 240,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(
                                    0xFFDDF0FA,
                                  ).withValues(alpha: 0.90),
                                  const Color(
                                    0xFFEBF5F8,
                                  ).withValues(alpha: 0.70),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Spacing reserve behind bottom sheet card
                const SizedBox(height: 140),
              ],
            ),
          ),

          // -----------------------------------------------------------
          // B. Brand Header (Leaf Logo + SolarDiagnostics + Tagline)
          // -----------------------------------------------------------
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: isCompact ? 16 : 32,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Green leaf logo
                    SolarLeafLogo(size: isCompact ? 48 : 58),
                    const SizedBox(height: 12),

                    // App Name
                    const Text(
                      'SolarDiagnostics',
                      style: TextStyle(
                        color: Color(0xFF1E3A2B), // Deep forest/dark emerald
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Tagline
                    const Text(
                      'Clean Energy. Better Tomorrow.',
                      style: TextStyle(
                        color: Color(0xFF2C5E43), // Rich emerald-tinted tagline
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // -----------------------------------------------------------
          // D. Bottom Actions Card (Sign In & Create Account)
          // -----------------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                22,
                14,
                22,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subtle top notch / drag pill
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7E3DC),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: isCompact ? 14 : 18),

                  // Button 1: "Sign In" (Emerald background, white text)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _navigateToSignIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Button 2: "Create Account" (White background, emerald border)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _navigateToCreateAccount(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryEmerald,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: AppColors.primaryEmerald,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// High-fidelity decorative backdrop if the image asset is loading or missing in testing
  static Widget _buildFallbackSolarBackdrop() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD6EEF9), Color(0xFFBCE1F2), Color(0xFFC7E6D7)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.solar_power_rounded,
          size: 140,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
