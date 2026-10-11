import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/solar_card.dart';

/// Clean empty state widget for when no solar systems or diagnostics are active.
class EmptyDashboardView extends StatelessWidget {
  final VoidCallback onRunInitialScan;
  final VoidCallback? onScanQr;

  const EmptyDashboardView({
    super.key,
    required this.onRunInitialScan,
    this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SolarCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.solar_power_outlined,
                  size: 36,
                  color: AppColors.primaryEmerald,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No System Data Yet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect your rooftop solar inverter or scan its QR code to register your system and monitor live telemetry.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Scan Inverter QR Code',
                icon: Icons.qr_code_scanner_rounded,
                onPressed: onScanQr ?? onRunInitialScan,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryEmerald),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onRunInitialScan,
                  icon: const Icon(Icons.troubleshoot_rounded, size: 18),
                  label: const Text(
                    'Run Baseline Diagnostics',
                    style: TextStyle(
                      color: AppColors.primaryEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
