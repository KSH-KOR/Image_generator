
import 'package:flutter/material.dart';

import '../services/image_generate_service.dart';
import '../utils/helper_widgets.dart';

class InputTextPanel extends StatelessWidget {
  const InputTextPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}