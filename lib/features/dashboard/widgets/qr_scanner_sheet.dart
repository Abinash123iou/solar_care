import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Scanned Solar Inverter Details Data Class
class ScannedSolarDetails {
  final String systemName;
  final String capacity;
  final String inverterModel;
  final String serialNumber;
  final String panelCount;
  final String gatewayIp;
  final String installationSite;

  const ScannedSolarDetails({
    required this.systemName,
    required this.capacity,
    required this.inverterModel,
    required this.serialNumber,
    required this.panelCount,
    required this.gatewayIp,
    required this.installationSite,
  });
}

/// Interactive QR Code Scanner Modal for linking rooftop solar system details
class QrScannerSheet extends StatefulWidget {
  final ValueChanged<ScannedSolarDetails> onDetailsDetected;

  const QrScannerSheet({super.key, required this.onDetailsDetected});

  @override
  State<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<QrScannerSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  bool _isTorchOn = false;
  bool _isProcessing = false;
  final TextEditingController _serialController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.08, end: 0.92).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  void _handleDetected(ScannedSolarDetails details) {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      widget.onDetailsDetected(details);
      Navigator.pop(context);
    });
  }

  void _simulatePresetScan({required String preset}) {
    if (preset == '5kw') {
      _handleDetected(
        const ScannedSolarDetails(
          systemName: 'Home Solar System',
          capacity: '5 kW',
          inverterModel: 'SolarCare Smart Hybrid SE-5000H',
          serialNumber: 'SN-INV-5000-CH89412',
          panelCount: '12x 415W Monocrystalline (4.98 kWp)',
          gatewayIp: '192.168.1.145 (Modbus TCP)',
          installationSite: 'Chennai, Tamil Nadu',
        ),
      );
    } else if (preset == '8kw') {
      _handleDetected(
        const ScannedSolarDetails(
          systemName: 'Rooftop Array 8kW',
          capacity: '8 kW',
          inverterModel: 'Sungrow SG8K-D Tri-Phase Inverter',
          serialNumber: 'SN-INV-8000-TN45109',
          panelCount: '20x 400W Bifacial Modules (8.0 kWp)',
          gatewayIp: '192.168.1.168 (Wi-Fi Dongle)',
          installationSite: 'Chennai, Tamil Nadu',
        ),
      );
    } else {
      _handleDetected(
        const ScannedSolarDetails(
          systemName: 'Residential Rooftop 3.3 kW',
          capacity: '3.3 kW',
          inverterModel: 'Growatt MIC 3300TL-X',
          serialNumber: 'SN-INV-3300-TN22904',
          panelCount: '8x 415W Tier-1 Panels (3.32 kWp)',
          gatewayIp: '192.168.1.189 (Ethernet)',
          installationSite: 'Chennai, Tamil Nadu',
        ),
      );
    }
  }

  void _showManualInputDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          title: const Text(
            'Enter Inverter Serial',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type the 12-character serial or gateway UID located on your inverter label:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _serialController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. INV-5000-CH89412',
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primaryEmerald,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryEmerald,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final serial = _serialController.text.trim().isEmpty
                    ? 'INV-5000-CH89412'
                    : _serialController.text.trim();
                Navigator.pop(ctx);
                _handleDetected(
                  ScannedSolarDetails(
                    systemName: 'Home Solar System',
                    capacity: '5 kW',
                    inverterModel: 'SolarCare Custom Inverter',
                    serialNumber: serial,
                    panelCount: '12x 415W Modules',
                    gatewayIp: '192.168.1.150',
                    installationSite: 'Chennai, Tamil Nadu',
                  ),
                );
              },
              child: const Text('Pair Inverter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFF131D17),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Inverter QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Align QR code within the frame to enter solar details',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Viewfinder Camera simulation area
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated dark camera feed background
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2E25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                ),

                // Viewfinder Frame
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Corner brackets
                      ..._buildCornerBrackets(),

                      // Animated Laser Scan Line
                      AnimatedBuilder(
                        animation: _laserAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: 250 * _laserAnimation.value,
                            left: 12,
                            right: 12,
                            child: Container(
                              height: 2.5,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF25D366,
                                    ).withValues(alpha: 0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Processing spinner overlay
                      if (_isProcessing)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryEmerald,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Reading Solar Details...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Camera Action Controls (Torch & Camera Flip)
                Positioned(
                  bottom: 20,
                  child: Row(
                    children: [
                      _buildControlPill(
                        icon: _isTorchOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        label: _isTorchOn ? 'Flash On' : 'Flash Off',
                        isActive: _isTorchOn,
                        onTap: () {
                          setState(() {
                            _isTorchOn = !_isTorchOn;
                          });
                        },
                      ),
                      const SizedBox(width: 14),
                      _buildControlPill(
                        icon: Icons.keyboard_rounded,
                        label: 'Manual Entry',
                        isActive: false,
                        onTap: _showManualInputDialog,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bottom card: Quick QR Sample / Scan Simulators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      color: AppColors.primaryEmerald,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Scan Inverter Barcode or QR Code',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Supported: Sungrow, SolarEdge, Growatt, Enphase, and custom QR tags.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                // Instant Scan Presets for testing
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: AppColors.primaryEmerald,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _simulatePresetScan(preset: '5kw'),
                        child: const Text(
                          'Scan 5 kW System',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: AppColors.primaryEmerald,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _simulatePresetScan(preset: '8kw'),
                        child: const Text(
                          'Scan 8 kW Array',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPill({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryEmerald : Colors.black45,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const double length = 26.0;
    const double thickness = 3.5;
    const Color cornerColor = Color(0xFF25D366);

    return [
      // Top-Left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: thickness,
          height: length,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),

      // Top-Right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: thickness,
          height: length,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),

      // Bottom-Left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: thickness,
          height: length,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),

      // Bottom-Right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: thickness,
          height: length,
          decoration: BoxDecoration(
            color: cornerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ];
  }
}
