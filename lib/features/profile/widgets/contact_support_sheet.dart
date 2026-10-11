import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

/// Modal bottom sheet presenting support options and installer assistance
class ContactSupportSheet extends StatelessWidget {
  const ContactSupportSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ContactSupportSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Text(
            'Certified Solar Technician Support',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Get technical assistance from certified rooftop solar installation partners.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 18),

          // Working hours & dispatch info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mintLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4EEDD)),
            ),
            child: Column(
              children: [
                _infoRow(
                  Icons.schedule_rounded,
                  'Support Hours',
                  'Mon – Sat • 8:00 AM – 7:00 PM IST',
                ),
                const SizedBox(height: 10),
                _infoRow(
                  Icons.verified_outlined,
                  'Technician Partner',
                  'SolarCare Certified Network (Tamil Nadu)',
                ),
                const SizedBox(height: 10),
                _infoRow(
                  Icons.emergency_outlined,
                  'Safety Advisory',
                  'Do NOT touch loose rooftop wires or inverter DC lines.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          PrimaryButton(
            label: 'Request Technician Callback',
            icon: Icons.phone_callback_rounded,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primaryEmerald,
                  content: Text(
                    'Technician callback requested. A certified installer will contact you within 2 business hours.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryEmerald),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF5A7265),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
