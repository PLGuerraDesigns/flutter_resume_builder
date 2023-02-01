import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    this.iconData,
    this.imageURL,
    required this.onPressed,
    required this.showImage,
  }) : super(key: key);

  final bool showImage;
  final IconData? iconData;
  final String? imageURL;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: IconButton(
          onPressed: onPressed,
          icon: showImage ? Image.network(imageURL!) : Icon(iconData),
        ),
      ),
    );
  }
}
