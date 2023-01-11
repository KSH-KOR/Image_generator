import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mut_is/utils/helper_widgets.dart';
import 'package:provider/provider.dart';
import 'sharepage.dart';
import '../enum/search_states.dart';
import '../services/image_generate_service.dart';
import '../services/prompt_service.dart';
import '../widgets/app_header.dart';
import '../widgets/form_submit_button.dart';
import '../widgets/prompt_text_form.dart';
import '../widgets/search_bottom_sheet.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    PromptProvider.textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFF0A0B12), body: Center(child: ShareButton())
          // body: Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     const Padding(
          //       padding:
          //           EdgeInsets.only(top: 52, bottom: 29, left: 20, right: 20),
          //       child: AppHeader(),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: ConstrainedBox(
          //         constraints: BoxConstraints(
          //           maxWidth: MediaQuery.of(context).size.width,
          //           maxHeight: 186.0 / 844.0 * MediaQuery.of(context).size.height,
          //         ),
          //         child: Stack(
          //           children: const [
          //             PromptTextForm(),
          //             Align(
          //               alignment: Alignment(0.95, 0.8),
          //               child: FormSubmitButton(),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     addVerticalGap(28),
          //     Expanded(
          //       child: Visibility(
          //         visible: Provider.of<PromptProvider>(context).isSearchingMode,
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 20),
          //           child: SearchBottomSheet(),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
