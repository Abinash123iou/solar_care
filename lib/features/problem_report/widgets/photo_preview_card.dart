import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/problem_report_model.dart';

/// Interactive preview card for each attached rooftop solar photo
/// Displays thumbnail, removal button, enlarged preview trigger, and editable photo description.
class PhotoPreviewCard extends StatefulWidget {
  final PhotoAttachment photo;
  final VoidCallback onRemove;
  final ValueChanged<String> onDescriptionChanged;

  const PhotoPreviewCard({
    super.key,
    required this.photo,
    required this.onRemove,
    required this.onDescriptionChanged,
  });

  @override
  State<PhotoPreviewCard> createState() => _PhotoPreviewCardState();
}

class _PhotoPreviewCardState extends State<PhotoPreviewCard> {
  late final TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.photo.description);
  }

  @override
  void didUpdateWidget(covariant PhotoPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo.description != widget.photo.description &&
        _captionController.text != widget.photo.description) {
      _captionController.text = widget.photo.description;
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _showEnlargedPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImageWidget(fit: BoxFit.contain),
              ),
              if (widget.photo.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.photo.description,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget({BoxFit fit = BoxFit.cover}) {
    final uri = widget.photo.imageUri;
    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      return Image.network(
        uri,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.mint,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryEmerald,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Local file path
      try {
        final file = File(uri);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
          );
        }
      } catch (_) {
        // Fallback if not direct file system access (e.g. web)
      }
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.mint,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.solar_power_rounded,
              color: AppColors.primaryEmerald,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              widget.photo.label,
              style: const TextStyle(
                color: AppColors.primaryEmerald,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(12),
      borderRadius: AppTheme.cardRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with enlarge tap
          GestureDetector(
            onTap: () => _showEnlargedPreview(context),
            child: Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImageWidget(),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.zoom_in_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Photo details and caption field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.photo.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: widget.onRemove,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.statusDangerBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: AppColors.statusDanger,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: TextField(
                    controller: _captionController,
                    onChanged: widget.onDescriptionChanged,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Describe this photo...',
                      hintStyle: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
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
