

import 'package:flutter/material.dart';

import '../services/image_generate_service.dart';

class ImageBackgroundPart extends StatelessWidget {
  const ImageBackgroundPart({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenAIProvider.images![0];
  }
}
