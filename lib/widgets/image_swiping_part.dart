



import 'package:flutter/material.dart';

import '../services/image_generate_service.dart';


class ImageSwipingPart extends StatefulWidget {
  const ImageSwipingPart({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageSwipingPart> createState() => _ImageSwipingPartState();
}

class _ImageSwipingPartState extends State<ImageSwipingPart> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: OpenAIProvider.images?.length ?? 0,
        itemBuilder: (context, index) => SizedBox(
              height: MediaQuery.of(context).size.height * 408.0 / 884.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: OpenAIProvider.images?[index] ?? const Text("No image"),
              ),
      ),
    );
  }
}
