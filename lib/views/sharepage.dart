import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          const urlImage =
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREtyPmQD7DAeXeJYJpkcLkchzYMXKUPaiE0g&usqp=CAU";
          final url = Uri.parse(urlImage);
          final response = await http.get(url);
          final bytes = response.bodyBytes;

          final temp = await getTemporaryDirectory();
          final path = "${temp.path}/image.jpg";
          File(path).writeAsBytes(bytes);

          await Share.shareFiles([path]);
        },
        child: Text(
          "Hello",
          style: TextStyle(color: Colors.white),
        ));
  }
}
