import 'package:flutter/material.dart';

class RemoteImage extends StatelessWidget {
  const RemoteImage({
    required this.url,
    this.height,
    this.width,
    this.radius = 18,
    super.key,
  });
  final String url;
  final double? height, width;
  final double radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.network(
      url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.orange.shade100,
        child: const Icon(Icons.image_not_supported_outlined),
      ),
    ),
  );
}
