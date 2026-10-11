import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/problem_report_model.dart';

/// Service managing device photo acquisition, camera simulation, and limit enforcement.
class PhotoPickerService {
  static const int maxPhotoLimit = 5;

  // Realistic rooftop solar diagnostic photos for testing and simulator fallbacks
  static const List<Map<String, String>> sampleSolarPhotos = [
    {
      'label': 'Panel Surface Dust / Soiling',
      'url':
          'https://images.unsplash.com/photo-1508873696983-2df57046475a?auto=format&fit=crop&w=600&q=80',
      'desc': 'Visible dust layer on lower modules of string B.',
    },
    {
      'label': 'Tree Branch Shading',
      'url':
          'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80',
      'desc': 'Partial shading on 3 panels from adjacent oak tree.',
    },
    {
      'label': 'Inverter LCD Fault Code',
      'url':
          'https://images.unsplash.com/photo-1558441719-8b489c634a10?auto=format&fit=crop&w=600&q=80',
      'desc': 'Inverter display showing fault code E022 - Isolation Fault.',
    },
    {
      'label': 'Glass Micro-crack',
      'url':
          'https://images.unsplash.com/photo-1545209575-8120613d98bb?auto=format&fit=crop&w=600&q=80',
      'desc': 'Hairline fracture on corner glass of panel #7.',
    },
    {
      'label': 'Cable / MC4 Connector Junction',
      'url':
          'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?auto=format&fit=crop&w=600&q=80',
      'desc': 'Loose wiring clip near junction box.',
    },
  ];

  /// Shows the photo selection bottom sheet (Camera, Gallery, or Solar Presets)
  static void showPhotoSourceSelector({
    required BuildContext context,
    required int currentPhotoCount,
    required ValueChanged<PhotoAttachment> onPhotoSelected,
  }) {
    if (currentPhotoCount >= maxPhotoLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.statusWarning,
          content: Text('Maximum limit of 5 photos reached.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attach Rooftop Photo',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$currentPhotoCount / $maxPhotoLimit photos',
                      style: const TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Take a photo with the camera or choose from your gallery:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.mint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primaryEmerald,
                  ),
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Capture inverter plate or panel condition',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _simulateCameraCapture(
                    context,
                    currentPhotoCount,
                    onPhotoSelected,
                  );
                },
              ),
              const SizedBox(height: 6),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.mint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primaryEmerald,
                  ),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Select an existing photo from storage'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _simulateGalleryPick(
                    context,
                    currentPhotoCount,
                    onPhotoSelected,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  static void _simulateCameraCapture(
    BuildContext context,
    int currentCount,
    ValueChanged<PhotoAttachment> onPhotoSelected,
  ) {
    final sampleIndex = currentCount % sampleSolarPhotos.length;
    final sample = sampleSolarPhotos[sampleIndex];

    final photo = PhotoAttachment(
      id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      imageUri: sample['url']!,
      label: 'Camera: ${sample['label']!}',
      description: sample['desc']!,
      isSamplePhoto: true,
    );

    onPhotoSelected(photo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryEmerald,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('Captured photo: ${sample['label']!}')),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void _simulateGalleryPick(
    BuildContext context,
    int currentCount,
    ValueChanged<PhotoAttachment> onPhotoSelected,
  ) {
    final sampleIndex = (currentCount + 1) % sampleSolarPhotos.length;
    final sample = sampleSolarPhotos[sampleIndex];

    final photo = PhotoAttachment(
      id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      imageUri: sample['url']!,
      label: 'Gallery: ${sample['label']!}',
      description: sample['desc']!,
      isSamplePhoto: true,
    );

    onPhotoSelected(photo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryEmerald,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('Selected: ${sample['label']!}')),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
