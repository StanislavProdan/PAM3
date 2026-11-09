import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.action, super.key});
  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      if (action != null)
        Text(
          action!,
          style: const TextStyle(
            color: Color(0xFFFF6F00),
            fontWeight: FontWeight.w700,
          ),
        ),
    ],
  );
}
