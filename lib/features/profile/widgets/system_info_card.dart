import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/user_profile_model.dart';

/// Card presenting solar system specifications, capacity, and installation details
class SystemInfoCard extends StatelessWidget {
  final UserProfile profile;

  const SystemInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with Demo Data badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'REGISTERED SOLAR SYSTEM',
                style: TextStyle(
                  color: Color(0xFF6B8274),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Active System',
                  style: TextStyle(
                    color: Color(0xFF5A7265),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Primary system title
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.solar_power_rounded,
                  color: AppColors.primaryEmerald,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.systemName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.inverterModel,
                      style: const TextStyle(
                        color: Color(0xFF5A7265),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          // Detail specs
          _specRow(
            icon: Icons.electric_bolt_rounded,
            label: 'System Capacity',
            value: profile.systemCapacity,
          ),
          const SizedBox(height: 8),
          _specRow(
            icon: Icons.calendar_today_rounded,
            label: 'Commissioning Date',
            value: profile.installationDate,
          ),
          const SizedBox(height: 8),
          _specRow(
            icon: Icons.location_on_outlined,
            label: 'Site Address',
            value: profile.installationAddress,
          ),
        ],
      ),
    );
  }

  Widget _specRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B8274)),
        const SizedBox(width: 8),
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B8274),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
