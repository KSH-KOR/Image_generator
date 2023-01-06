import 'dart:ui';

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
    List<String> imageURLs = getImageURLsFromResponse(
                    response: ModalRoute.of(context)!.settings.arguments
                        as openapi.Response?);
    return Scaffold(
      backgroundColor: Color(0xFF0A0B12),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageURLs[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  addVerticalGap(49),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 73,
                        height: 31,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9D9D9).withOpacity(0.04),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.center,
                            side: BorderSide(width: 1, color: Color(0xFFF76691),)
                          ),
                          onPressed: Navigator.of(context).pop,
                          child: const Text(
                            "Home",
                            style: TextStyle(
                              color: Color(0xFFF76691),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  addVerticalGap(40),
                  const Text("TEXT ARTIST", style: TextStyle(color: Color(0xFFF76691),),),
                  addVerticalGap(17),
                  ImageSwipingPart(
                      imageURLs: imageURLs),
                  addVerticalGap(11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.download, color: Color(0xFFF76691),)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.share, color: Color(0xFFF76691),)),
                    ],
                  ),
                  addVerticalGap(29),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.04),
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 106.0 / 844.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("INTPUT TEXT", style: TextStyle(color: Color(0xFFF76691),),),
                          addVerticalGap(17),
                          Text(OpenAIProvider.prompt, style: const TextStyle(color: Color(0xFFF76691),),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageBackgroundPart extends StatelessWidget {
  const ImageBackgroundPart({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenAIProvider.images![0];
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
