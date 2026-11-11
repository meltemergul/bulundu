import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing_draft.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/platform_info.dart';
import 'package:bulundu/shared/widgets/app_image.dart';

class ImagePickerField extends StatefulWidget {
  const ImagePickerField({
    super.key,
    required this.existingImageUrls,
    required this.newImages,
    required this.onAddImage,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  final List<String> existingImageUrls;
  final List<PickedImageItem> newImages;
  final ValueChanged<PickedImageItem> onAddImage;
  final ValueChanged<int> onRemoveExisting;
  final ValueChanged<int> onRemoveNew;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  bool _isProcessing = false;

  int get _totalCount =>
      widget.existingImageUrls.length + widget.newImages.length;

  Future<void> _pick(ImageSource source) async {
    final l10n = context.l10n;
    setState(() => _isProcessing = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 80,
      );
      if (picked == null) {
        if (mounted) setState(() => _isProcessing = false);
        return;
      }

      final rawBytes = await picked.readAsBytes();
      if (rawBytes.isEmpty) {
        if (mounted) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorGeneric)),
          );
        }
        return;
      }

      final processedBytes = await _optimizeImageBytes(rawBytes);

      if (mounted) {
        widget.onAddImage(
          PickedImageItem(file: picked, bytes: processedBytes),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf eklenemedi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  static Future<Uint8List> _optimizeImageBytes(Uint8List bytes) async {
    const maxAllowedBytes = 80 * 1024; // 80 KB limit for fast Firestore inline storage
    if (bytes.lengthInBytes <= maxAllowedBytes) {
      return bytes;
    }

    for (final targetWidth in [640, 480, 360, 240]) {
      try {
        final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: targetWidth,
        );
        final frame = await codec.getNextFrame();
        final byteData = await frame.image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData != null) {
          final resized = byteData.buffer.asUint8List();
          if (resized.lengthInBytes <= maxAllowedBytes || targetWidth == 240) {
            return resized;
          }
        }
      } catch (_) {
        break;
      }
    }
    return bytes;
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
              for (var i = 0; i < widget.existingImageUrls.length; i++)
                _PhotoThumb(
                  onRemove: () => widget.onRemoveExisting(i),
                  removeTooltip: l10n.removePhotoTooltip,
                  child: AppImage(
                    imageUrl: widget.existingImageUrls[i],
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
              for (var i = 0; i < widget.newImages.length; i++)
                _PhotoThumb(
                  onRemove: () => widget.onRemoveNew(i),
                  removeTooltip: l10n.removePhotoTooltip,
                  child: Image.memory(
                    widget.newImages[i].bytes,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) => Container(
                      color: context.colors.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (_isProcessing) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: AppSpacing.sm),
                Text('Fotoğraf işleniyor...'),
              ],
            ),
          ),
        ],
        if (canAddMore)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed:
                    _isProcessing ? null : () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.addPhotoGallery),
              ),
              if (supportsCamera)
                OutlinedButton.icon(
                  onPressed:
                      _isProcessing ? null : () => _pick(ImageSource.camera),
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
