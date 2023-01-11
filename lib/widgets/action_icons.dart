import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mut_is/services/image_generate_service.dart';
import 'package:provider/provider.dart';

class ActionIcons extends StatelessWidget {
  const ActionIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              final downloading = OpenAIProvider.downloadImage();
              late final SnackBar snackBar;
              await downloading.onError((error, stackTrace) {
                snackBar = const SnackBar(
                  content: Text('Image downloading failed!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              });
              await downloading.whenComplete((){
                snackBar = const SnackBar(
                  content: Text('Image downloaded!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
            icon: const Icon(
              Icons.download,
            )),
        const IconButton(
            onPressed: OpenAIProvider.shareImage,
            icon: Icon(
              Icons.share,
            )),
      ],
    );
  }
}
