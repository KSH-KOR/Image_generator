import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/prompt_service.dart';
import 'logo_image.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 65,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Visibility(
              visible: Provider.of<PromptProvider>(context).isSearchingMode,
              child: IconButton(
                onPressed: Provider.of<PromptProvider>(context, listen: false)
                    .cancelSearchingMode,
                icon:
                    const Icon(Icons.arrow_back_ios, color: Color(0xFFF76691)),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: LogoImage(imagePath: "assets/images/logo.png"),
          ),
        ],
      ),
    );
  }
}