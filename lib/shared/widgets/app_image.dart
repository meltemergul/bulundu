import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders either a network image or an inline Base64 data URI image.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext context, String url)? placeholder;
  final Widget Function(BuildContext context, String url, dynamic error)?
      errorWidget;

  static Uint8List? decodeDataUri(String uri) {
    try {
      final commaIndex = uri.indexOf(',');
      final base64String =
          commaIndex != -1 ? uri.substring(commaIndex + 1) : uri;
      return base64Decode(base64String.replaceAll(RegExp(r'\s+'), ''));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:')) {
      final bytes = decodeDataUri(imageUrl);
      if (bytes != null) {
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (ctx, err, _) =>
              errorWidget?.call(ctx, imageUrl, err) ??
              Container(
                width: width,
                height: height,
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              ),
        );
      }
      return errorWidget?.call(context, imageUrl, 'decode_error') ??
          Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

