import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mut_is/services/image_generate_service.dart';

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
            onPressed: () {
              log(OpenAIProvider.imageURLs![0]);
              FileDownloader.downloadFile(
                  url: OpenAIProvider.imageURLs![0],
                  name: "name",
                  onProgress: (String? fileName, double? progress) {
                    log('downloading');
                  },
                  onDownloadCompleted: (String path) {
                    log('FILE DOWNLOADED TO PATH: $path');
                  },
                  onDownloadError: (String error) {
                    log('DOWNLOAD ERROR: $error');
                  });
            },
            icon: const Icon(
              Icons.download,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
            )),
      ],
    );
  }
}
