
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return imagePath.endsWith(".svg")
        ? SvgPicture.asset(imagePath)
        : Image.asset(imagePath);
  }
}
