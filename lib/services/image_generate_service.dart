import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';

import 'package:http/http.dart' as http;

import 'package:image/image.dart' as eimage;

import '../enum/request_category.dart';

class ImageGenerateProvider extends ChangeNotifier{

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

File encodeJpgToPng({required File inputIpg}){
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



Request getRequest({RequestCategory requestCategory = RequestCategory.create, int n = 5, File? inputImage}){
  switch(requestCategory){
    case RequestCategory.create:
      return OpenAIProvider().client!.images.create(
        prompt: OpenAIProvider.prompt,
        n: n,
      );
    case RequestCategory.edit:
      if(inputImage == null) throw Error();
      return OpenAIProvider().client!.images.edit(
        image: encodeJpgToPng(inputIpg: inputImage),
        prompt: OpenAIProvider.prompt,
        n: n,
      );
    case RequestCategory.variations:
      if(inputImage == null) throw Error();
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
List<String> getImageURLsFromResponse({required Response response}){
  final Images image;
  try {
    image = response.get();
  } on StateError catch (_) {
    return [
      response.json['error']['message'],
    ];
  } catch (e) {
    return [
      "error occured: $e"
    ];
  }
  return image.data.map((e) => e.url,).toList();
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
