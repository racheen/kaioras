import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 250,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return _sizedContainer(
      CachedNetworkImage(
        maxHeightDiskCache: 10,
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset('assets/avatar_placeholder3.jpg'),
        fadeInDuration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }
}
