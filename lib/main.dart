import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';
import 'dart:developer' show log;

import 'package:http/http.dart' as http;

import 'package:image/image.dart' as eImage;
void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController textEditingController;
  bool _isSearched = false;
  @override
  void initState() {
    OpenAIProvider.apiKey =
        "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";
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('data')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: textEditingController,
                  ),
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        OpenAIProvider.prompt = textEditingController.text;
                        _isSearched = true;
                      });
                    },
                    child: const Text("Search")),
              ],
            ),
            Visibility(
              visible: _isSearched,
              child: ImageList(),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenAIProvider {
  static String prompt = '';
  static String? apiKey;

  OpenAIConfiguration? get conf => apiKey != null
      ? OpenAIConfiguration(
          apiKey: apiKey!,
        )
      : null;
  OpenAIClient? get client =>
      conf != null ? OpenAIClient(configuration: conf!) : null;
}

class ImageList extends StatelessWidget {
  const ImageList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final File inputImage = File("assets/sample.jpg");
    return FutureBuilder(
      future: createImagesWithOpenAI(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return snapshot.data == null
                ? const Center(
                    child: Text("error"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        height: 300,
                        child: FutureBuilder(
                          future: snapshot.data![index],
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                return snapshot.data ?? const Text("no image");
                              default:
                                return const CircularProgressIndicator();
                            }
                          },
                        ),
                      );
                    },
                  );
          default:
            return Column(
              children: const [
                Text("images generating.."),
                CircularProgressIndicator(),
              ],
            );
        }
      },
    );
  }
}
File encodeJpgToPng({required File inputIpg}){
  // Read a jpeg image from file.
  eImage.Image? image = eImage.decodeImage(inputIpg.readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  eImage.Image thumbnail = eImage.copyResize(image!, width: 120, height: 120);

  // Save the thumbnail as a PNG.
  return File.fromRawPath(eImage.encodePng(thumbnail));
}

Future<Uint8List> networkImageToBase64(String imageUrl) async {
  Uri uri = Uri.parse(imageUrl);
  var response = await http.get(uri);
  final bytes = response.bodyBytes;
  return bytes;
}

Future<List<Future<Widget>>> createImagesWithOpenAI({int n = 5}) async {
  final Request requestImage = OpenAIProvider().client!.images.create(
        prompt: OpenAIProvider.prompt,
        n: n,
      );
  return _getImagesFromRequest(request: requestImage);
}

Future<List<Future<Widget>>> editImagesWithOpenAI(
    {required File inputImage, int n = 5}) async {
  
  final Request requestImage = OpenAIProvider().client!.images.edit(
        image: encodeJpgToPng(inputIpg: inputImage),
        prompt: OpenAIProvider.prompt,
        n: n,
      );
  return _getImagesFromRequest(request: requestImage);
}

Future<List<Future<Widget>>> createDifferentVariationsWithOpenAI(
    {required File inputImage, int n = 5}) async {
  final Request requestImage = OpenAIProvider().client!.images.variation(
        image: inputImage,
        n: n,
      );
  return _getImagesFromRequest(request: requestImage);
}

Future<List<Future<Widget>>> _getImagesFromRequest({required Request request}) async {
  final Images image;
  late final Response response;
  try {
    response = await request.go();
    image = response.get();
  } on StateError catch (_) {
    return [
      Future.delayed(
        const Duration(seconds: 0),
        () => SelectableText(
          response.json['error']['message'],
        ),
      ),
    ];
  } catch (e) {
    return [
      Future.delayed(
        const Duration(seconds: 0),
        () => SelectableText("error occured: $e"),
      ),
    ];
  }

  return (image)
      .data
      .map((e) async => Image.memory(await networkImageToBase64(e.url)))
      .toList();
}
