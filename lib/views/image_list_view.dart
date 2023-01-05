import 'package:flutter/material.dart';
import 'package:mut_is/utils/helper_widgets.dart';
import 'package:openai_client/openai_client.dart' as openapi;

import '../services/image_generate_service.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({Key? key}) : super(key: key);

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0B12),
      body: Column(
        children: [
          addVerticalGap(49),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9).withOpacity(0.04),
                ),
                onPressed: Navigator.of(context).pop,
                child: const Text("Home"),
              ),
            ],
          ),
          ImageSwipingPart(
              imageURLs: getImageURLsFromResponse(
                  response: ModalRoute.of(context)!.settings.arguments
                      as openapi.Response)),
          addVerticalGap(11),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.bubble_chart)),
              IconButton(onPressed: () {}, icon: Icon(Icons.bubble_chart)),
            ],
          ),
          addVerticalGap(29),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.04),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 106.0 / 844.0,
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}

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
  late final List<Image> imageList;
  @override
  void initState() {
    imageList = widget.imageURLs
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
        itemCount: imageList.length,
        itemBuilder: (context, index) => SizedBox(
              height: MediaQuery.of(context).size.height * 408.0 / 884.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageList[index],
              ),
      ),
    );
  }
}
