


import 'package:flutter/material.dart';

import '../services/image_generate_service.dart';

class ImageSwipingPart extends StatefulWidget {
  const ImageSwipingPart({
    Key? key,
    required this.imageURLs,
  }) : super(key: key);

  final List<String> imageURLs;

  @override
  State<ImageSwipingPart> createState() => _ImageSwipingPartState();
}

class _ImageSwipingPartState extends State<ImageSwipingPart> {
  @override
  void initState() {
    OpenAIProvider.images = widget.imageURLs
        .map((url) => Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text("image load failed. error message: $url");
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF76691),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ))
        .toList();
    super.initState();
  }

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
