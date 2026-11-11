import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/platform_info.dart';

class ImagePickerField extends StatelessWidget {
  const ImagePickerField({
    super.key,
    required this.existingImageUrls,
    required this.newImages,
    required this.onAddImage,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  final List<String> existingImageUrls;
  final List<XFile> newImages;
  final ValueChanged<XFile> onAddImage;
  final ValueChanged<int> onRemoveExisting;
  final ValueChanged<int> onRemoveNew;

  int get _totalCount => existingImageUrls.length + newImages.length;

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 80,
    );
    if (picked != null) {
      onAddImage(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canAddMore = _totalCount < 3;
    final supportsCamera = PlatformInfo.supportsCamera();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.listingPhotosLabel, style: context.textStyles.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (_totalCount > 0) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < existingImageUrls.length; i++)
                _PhotoThumb(
                  onRemove: () => onRemoveExisting(i),
                  removeTooltip: l10n.removePhotoTooltip,
                  child: CachedNetworkImage(
                    imageUrl: existingImageUrls[i],
                    fit: BoxFit.cover,
                    placeholder: (context, _) => Container(
                      color: context.colors.surfaceContainerHighest,
                    ),
                    errorWidget: (context, _, _) => Container(
                      color: context.colors.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              for (var i = 0; i < newImages.length; i++)
                _PhotoThumb(
                  onRemove: () => onRemoveNew(i),
                  removeTooltip: l10n.removePhotoTooltip,
                  child: FutureBuilder<Uint8List>(
                    future: newImages[i].readAsBytes(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Container(
                          color: context.colors.surfaceContainerHighest,
                        );
                      }
                      return Image.memory(snap.data!, fit: BoxFit.cover);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (canAddMore)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.addPhotoGallery),
              ),
              if (supportsCamera)
                OutlinedButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.addPhotoCamera),
                ),
            ],
          ),
      ],
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.child,
    required this.onRemove,
    required this.removeTooltip,
  });

  final Widget child;
  final VoidCallback onRemove;
  final String removeTooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.xxl * 2,
      height: AppSpacing.xxl * 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: child,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton.filledTonal(
              tooltip: removeTooltip,
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: AppSpacing.md),
            ),
          ),
        ],
      ),
    );
  }
}
