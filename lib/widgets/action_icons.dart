

import 'package:flutter/material.dart';

class ActionIcons extends StatelessWidget {
  const ActionIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.download, color: Color(0xFFF76691),)),
        IconButton(onPressed: () {}, icon: Icon(Icons.share, color: Color(0xFFF76691),)),
      ],
    );
  }
}