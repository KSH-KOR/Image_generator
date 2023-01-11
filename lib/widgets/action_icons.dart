
import 'package:flutter/material.dart';
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
            onPressed: () async {
              final downloading = OpenAIProvider.downloadImage();
              late final SnackBar snackBar;
              downloading.onError((error, stackTrace) {
                snackBar = const SnackBar(
                  content: Text('Image downloading failed!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              });
              downloading.then((bool? isSucceeded){
                snackBar = SnackBar(
                  content: (isSucceeded == null || !isSucceeded) ? const Text('Image downloading failed!') : const Text('Image downloaded!')
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
          ),
        ),
      ],
    );
  }
}
