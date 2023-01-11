import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mut_is/theme/app_layout.dart';
import 'package:mut_is/utils/helper_widgets.dart';
import 'package:provider/provider.dart';

import '../services/image_generate_service.dart';
import '../services/prompt_service.dart';
import '../widgets/app_header.dart';
import '../widgets/form_submit_button.dart';
import '../widgets/prompt_text_form.dart';
import '../widgets/search_bottom_sheet.dart';
import '../widgets/selectable_keyword_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    PromptProvider.textEditingController = TextEditingController();
    OpenAIProvider.apiKey =
        "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";
    log(OpenAIProvider.apiKey!);
    super.initState();
  }

  @override
  void dispose() {
    PromptProvider.textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B12),
        body: AppLayout.mainContentLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addVerticalGap(52),
              const AppHeader(),
              addVerticalGap(29),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: 186.0 / 844.0 * MediaQuery.of(context).size.height,
                ),
                child: Stack(
                  children: const [
                    PromptTextForm(),
                    Align(
                      alignment: Alignment(0.95, 0.8),
                      child: FormSubmitButton(),
                    ),
                  ],
                ),
              ),
              addVerticalGap(28),
              Expanded(
                child: Visibility(
                  visible: Provider.of<PromptProvider>(context).isSearchingMode,
                  child: const SearchBottomSheet(),
                ),
              ),
              Visibility(
                  visible:
                      !Provider.of<PromptProvider>(context).isSearchingMode,
                  child: const SelectableKeywordPanel()),
              addVerticalGap(10),
            ],
          ),
        ),
      ),
    );
  }
}
