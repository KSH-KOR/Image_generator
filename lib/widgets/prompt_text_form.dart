import 'dart:developer';

import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/prompt_service.dart';

class PromptTextForm extends StatelessWidget {
  const PromptTextForm({super.key});

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height/3,
      ),
      child: TextField(
        maxLines: 10,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          enabled: true/*promptProvider.enabled*/,
          controller: PromptProvider.textEditingController,
          onChanged: (_) {
            promptProvider.setSearchState();
          },
          onTap: () => promptProvider.enabled = true,
          onSubmitted: (value) {
            promptProvider.addKeyword(keyword: value);
            promptProvider.enabled = false;
          },
        ),
    );
  }
}