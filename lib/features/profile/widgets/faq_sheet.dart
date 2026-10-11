import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Modal bottom sheet presenting Frequently Asked Questions on solar diagnostics
class FaqSheet extends StatelessWidget {
  const FaqSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const FaqSheet(),
    );
  }

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'What does Inverter Fault code E022 indicate?',
      'a':
          'Error code E022 indicates an Isolation / Ground Fault. The inverter detected low resistance between DC wiring and earth grounding (< 1.0 MΩ standard), often triggered by morning moisture or loose connector seals.',
    },
    {
      'q': 'How frequently should rooftop solar panels be cleaned?',
      'a':
          'Inspecting panels every 3 to 6 months is recommended. In dusty or high-pollen regions, a gentle low-pressure rinse early in the morning before panels heat up can restore up to 15% lost generation.',
    },
    {
      'q': 'How does the SolarCare rule-engine analysis work?',
      'a':
          'SolarCare continuously evaluates string DC voltages, AC export levels, and ambient conditions against expected nominal production to isolate string imbalances, soiling, and grid voltage spikes.',
    },
    {
      'q': 'Why does solar yield derate on very hot afternoons?',
      'a':
          'Solar panels and inverters have negative temperature coefficients. When ambient temperatures exceed 40°C, inverters automatically derate output power by 15-30% to protect internal silicon semiconductors from overheating.',
    },
    {
      'q': 'When is an on-site technician visit required?',
      'a':
          'Contact a qualified solar technician whenever physical damage is observed, isolation error codes persist after safe reboots, or DC string open-circuit voltage remains depressed.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
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
            'Frequently Asked Questions',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'SolarCare diagnostic knowledge base & troubleshooting guidance.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _faqs.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final item = _faqs[index];
                return Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    title: Text(
                      item['q']!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    children: [
                      Text(
                        item['a']!,
                        style: const TextStyle(
                          color: Color(0xFF5A7265),
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
