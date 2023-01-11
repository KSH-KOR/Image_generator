import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:openai_client/openai_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;

import 'package:image/image.dart' as eimage;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../enum/request_category.dart';

class ImageGenerateProvider extends ChangeNotifier {
  bool _isJustGenerated = false;
  set isJustGenerated(bool newVal) {
    _isJustGenerated = newVal;
    notifyListeners();
  }

  bool get isJustGenerated => _isJustGenerated;
}

class OpenAIProvider {
  static List<String>? imageURLs;
  static String? currImageUrl;
  static String? imageLocalPath;
  static Uint8List? temporarImageByteData;
  static String prompt = '';
  static String? apiKey;

  static Future<void> imageStoreInDevice() async {
    temporarImageByteData =
        (await http.get(Uri.parse(imageURLs![0]))).bodyBytes;
    final tempPath = (await getTemporaryDirectory()).path;
    imageLocalPath = "$tempPath/generatedImageByOpenAI.jpg";
    File(imageLocalPath!).writeAsBytes(temporarImageByteData!);
  }

  static Future<bool?> downloadImage() async {
    if (imageLocalPath == null) return null;
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
        bool status = await Permission.storage.isGranted;

        if (!status) await Permission.storage.request();
      }
    }
    return GallerySaver.saveImage(imageLocalPath!, albumName: "TextArtist");
  }

  static Future<void> shareImage() async {
    if (imageLocalPath == null) return;
    return await Share.shareFiles([imageLocalPath!]);
  }
  static get images => imageURLs?.map((url) {
    return Image.network(
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
    );
  }).toList();

  OpenAIConfiguration? get conf => apiKey != null
      ? OpenAIConfiguration(
          apiKey: apiKey!,
        )
      : null;
  OpenAIClient? get client =>
      conf != null ? OpenAIClient(configuration: conf!) : null;
}

File encodeJpgToPng({required File inputIpg}) {
  // Read a jpeg image from file.
  eimage.Image? image = eimage.decodeImage(inputIpg.readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  eimage.Image thumbnail = eimage.copyResize(image!, width: 120, height: 120);

  // Save the thumbnail as a PNG.
  return File.fromRawPath(eimage.encodePng(thumbnail));
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

Request getRequest(
    {RequestCategory requestCategory = RequestCategory.create,
    int n = 5,
    File? inputImage}) {
  switch (requestCategory) {
    case RequestCategory.create:
      return OpenAIProvider().client!.images.create(
            prompt: OpenAIProvider.prompt,
            n: n,
          );
    case RequestCategory.edit:
      if (inputImage == null) throw Error();
      return OpenAIProvider().client!.images.edit(
            image: encodeJpgToPng(inputIpg: inputImage),
            prompt: OpenAIProvider.prompt,
            n: n,
          );
    case RequestCategory.variations:
      if (inputImage == null) throw Error();
      return OpenAIProvider().client!.images.variation(
            image: encodeJpgToPng(inputIpg: inputImage),
            n: n,
          );
  }
}

Future<Response> getResponse({required Request request}) async {
  try {
    return await request.go();
  } on StateError catch (_) {
    rethrow;
  } catch (e) {
    rethrow;
  }
}

List<String> getImageURLsFromResponse({required Response? response}) {
  final Images image;
  if (response == null) {
    return [
      "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
    ];
  }
  try {
    image = response.get();
  } on StateError catch (_) {
    return [
      response.json['error']['message'],
    ];
  } catch (e) {
    return ["error occured: $e"];
  }
  return image.data
      .map(
        (e) => e.url,
      )
      .toList();
}

Future<List<Future<Widget>>> _getImagesFromRequest(
    {required Request request}) async {
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
