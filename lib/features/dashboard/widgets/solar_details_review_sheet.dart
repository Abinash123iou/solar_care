import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/solar_card.dart';
import 'qr_scanner_sheet.dart';

/// Modal to review and confirm scanned solar system details before applying to dashboard
class SolarDetailsReviewSheet extends StatelessWidget {
  final ScannedSolarDetails details;
  final VoidCallback onConfirm;

  const SolarDetailsReviewSheet({
    super.key,
    required this.details,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryEmerald,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solar Details Detected',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Inverter QR verified and calibrated',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Details breakdown card
          SolarCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _detailRow('System Name', details.systemName, isBold: true),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Rated Capacity', details.capacity, highlight: true),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Inverter Model', details.inverterModel),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Serial Number', details.serialNumber),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Solar Panels', details.panelCount),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Gateway IP', details.gatewayIp),
                const Divider(height: 18, color: AppColors.borderSubtle),
                _detailRow('Site Location', details.installationSite),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Action Buttons
          PrimaryButton(
            label: 'Save & Connect to Dashboard',
            icon: Icons.link_rounded,
            onPressed: onConfirm,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isBold = false,
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5E7368),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: highlight
                  ? AppColors.primaryEmerald
                  : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: (isBold || highlight)
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
