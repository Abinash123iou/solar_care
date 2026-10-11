import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';

/// Clean loading placeholder matching the Dashboard layout structure.
class LoadingDashboardView extends StatefulWidget {
  const LoadingDashboardView({super.key});

  @override
  State<LoadingDashboardView> createState() => _LoadingDashboardViewState();
}

class _LoadingDashboardViewState extends State<LoadingDashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.35,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.borderSubtle.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card skeleton
          SolarCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(width: 150, height: 20),
                    _shimmerBox(width: 60, height: 24, borderRadius: 12),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.borderSubtle),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _shimmerBox(width: 68, height: 68, borderRadius: 34),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(width: 120, height: 18),
                          const SizedBox(height: 8),
                          _shimmerBox(width: double.infinity, height: 14),
                          const SizedBox(height: 6),
                          _shimmerBox(width: 140, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Button skeleton
          _shimmerBox(width: double.infinity, height: 50, borderRadius: 14),
          const SizedBox(height: 24),
          // Metrics grid skeleton
          Row(
            children: [
              Expanded(
                child: SolarCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 32, height: 32, borderRadius: 8),
                      const SizedBox(height: 10),
                      _shimmerBox(width: 70, height: 12),
                      const SizedBox(height: 6),
                      _shimmerBox(width: 90, height: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SolarCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 32, height: 32, borderRadius: 8),
                      const SizedBox(height: 10),
                      _shimmerBox(width: 70, height: 12),
                      const SizedBox(height: 6),
                      _shimmerBox(width: 90, height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Component list item skeleton
          _shimmerBox(width: 160, height: 18),
          const SizedBox(height: 12),
          SolarCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _shimmerBox(width: 40, height: 40, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 110, height: 14),
                      const SizedBox(height: 6),
                      _shimmerBox(width: 180, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
