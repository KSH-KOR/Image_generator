import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mut_is/utils/helper_widgets.dart';
import 'package:openai_client/openai_client.dart' as openapi;
import 'package:provider/provider.dart';

import '../services/image_generate_service.dart';
import '../widgets/action_icons.dart';
import '../widgets/back_to_home_button.dart';
import '../widgets/image_swiping_part.dart';
import '../widgets/input_text_panel.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({Key? key}) : super(key: key);
  

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B12),
      body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    children: [
                      addVerticalGap(49),
                      const BackToHomeButton(),
                      addVerticalGap(40),
                      const Text(
                        "TEXT ARTIST",
                        style: TextStyle(
                          color: Color(0xFFF76691),
                        ),
                      ),
                      addVerticalGap(17),
                      const ImageSwipingPart(),
                      addVerticalGap(11),
                      const Visibility(
                        visible: true,
                        child: ActionIcons(),
                      ),
                      addVerticalGap(29),
                      const InputTextPanel(),
                    ],
                  ),
                ),
              ),
          ),
          
      
    );
  }
}
