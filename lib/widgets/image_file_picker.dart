import 'dart:typed_data';

import 'package:flutter/material.dart';

/// A button that displays an image. The image can be changed.
class ImageFilePicker extends StatelessWidget {
  const ImageFilePicker({
    super.key,
    required this.logoFileBytes,
    required this.onPressed,
  });

  /// The image to display as a byte array.
  final Uint8List? logoFileBytes;

  /// The callback when the user presses the button.
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      width: 118,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: IconButton(
          onPressed: onPressed,
          icon: logoFileBytes == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                )
              : Image.memory(logoFileBytes!),
        ),
      ),
    );
  }
}
