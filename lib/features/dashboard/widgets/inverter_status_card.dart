import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/solar_card.dart';

/// Inverter Status Card for the SolarCare Dashboard.
/// Displays real-time operating metrics, AC/DC conversion stats, and inverter health.
class InverterStatusCard extends StatelessWidget {
  final String inverterModel;
  final String status;
  final double acPowerKw;
  final double dcVoltageV;
  final double temperatureC;
  final double efficiencyPercent;
  final String gridStatus;
  final VoidCallback? onTap;

  const InverterStatusCard({
    super.key,
    this.inverterModel = 'Sungrow SG5.0RS (Single Phase)',
    this.status = 'Online • Generating',
    this.acPowerKw = 3.85,
    this.dcVoltageV = 340.0,
    this.temperatureC = 41.8,
    this.efficiencyPercent = 98.2,
    this.gridStatus = '50.0 Hz Synchronized',
    this.onTap,
  });

  void _showInverterDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
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
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.developer_board_rounded,
                      color: AppColors.primaryEmerald,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inverterModel,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'String Inverter Telemetry & Diagnostic Health',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Telemetry Grid
              Row(
                children: [
                  Expanded(
                    child: _buildDetailTile(
                      label: 'AC Active Power',
                      value: '${acPowerKw.toStringAsFixed(2)} kW',
                      sub: '230 V • 16.7 A',
                      icon: Icons.bolt_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailTile(
                      label: 'DC Array Input',
                      value: '${dcVoltageV.toStringAsFixed(0)} V',
                      sub: 'PV1: 340V • PV2: 335V',
                      icon: Icons.solar_power_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailTile(
                      label: 'Internal Temp',
                      value: '${temperatureC.toStringAsFixed(1)} °C',
                      sub: 'Normal (< 55°C)',
                      icon: Icons.thermostat_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailTile(
                      label: 'Inverter Efficiency',
                      value: '${efficiencyPercent.toStringAsFixed(1)}%',
                      sub: 'MPPT Tracking: 99.8%',
                      icon: Icons.speed_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailTile(
                      label: 'Grid Connection',
                      value: 'Synchronized',
                      sub: gridStatus,
                      icon: Icons.electrical_services_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailTile(
                      label: 'Active Fault Codes',
                      value: 'None (Clean)',
                      sub: 'Isolation Res: >20 MΩ',
                      icon: Icons.check_circle_outline_rounded,
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Close Inverter Telemetry',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildDetailTile({
    required String label,
    required String value,
    required String sub,
    required IconData icon,
    bool isPositive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPositive ? AppColors.mintLight : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPositive
              ? AppColors.primaryEmerald.withValues(alpha: 0.3)
              : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isPositive
                    ? AppColors.primaryEmerald
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          _showInverterDetails(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Status Pill
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.developer_board_rounded,
                  color: AppColors.primaryEmerald,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inverter Status',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      inverterModel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Live Online badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mintLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryEmerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ONLINE',
                      style: TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 3 Metric Pills
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  title: 'AC Power',
                  value: '${acPowerKw.toStringAsFixed(2)} kW',
                  icon: Icons.bolt_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: AppColors.borderSubtle,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildMetricItem(
                  title: 'Temperature',
                  value: '${temperatureC.toStringAsFixed(1)} °C',
                  icon: Icons.thermostat_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: AppColors.borderSubtle,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildMetricItem(
                  title: 'Efficiency',
                  value: '${efficiencyPercent.toStringAsFixed(1)}%',
                  icon: Icons.speed_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sync_rounded,
                    size: 13,
                    color: Color(0xFF6B8075),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    gridStatus,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B8075),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primaryEmerald,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
