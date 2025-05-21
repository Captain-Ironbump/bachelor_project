import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';

class ReportLeadingInformation extends StatelessWidget {
  final MarkdownFormEntity markdownFormEntity;

  const ReportLeadingInformation({
    super.key,
    required this.markdownFormEntity,
  });

  String _calculateReportSize(String report) {
    final bytes = utf8.encode(report);
    final int byteCount = bytes.length;

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = byteCount.toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.floor()} ${units[unitIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, // adjust based on your actual content height
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left clipped container
          Positioned(
            left: 0,
            child: ClipPath(
              clipper: _DiagonalRightClipper(),
              child: Container(
                width: 60,
                decoration: const BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                padding: const EdgeInsets.only(left: 5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  _calculateReportSize(markdownFormEntity.report!),
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          // Right clipped container
          if (markdownFormEntity.quality != null)
            Positioned(
              left: 45, // shift left to overlap, tweak if needed
              child: ClipPath(
                clipper: _DiagonalLeftClipper(),
                child: Container(
                  width: 60,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.activeGreen,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  padding: const EdgeInsets.only(right: 5.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    markdownFormEntity.quality!,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DiagonalRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 20, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DiagonalLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(20, 0) // Start 20px right
      ..lineTo(size.width, 0) // Top right corner
      ..lineTo(size.width, size.height) // Bottom right corner
      ..lineTo(0, size.height) // Bottom left corner
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
