import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/prompt_service.dart';

class PromptTextForm extends StatelessWidget {
  const PromptTextForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _promptProvider = Provider.of<PromptProvider>(context);
    return Container(
      child: TextField(
        enabled: _promptProvider.enabled,
        autofocus: _promptProvider.enabled,
        controller: PromptProvider.textEditingController,
        onChanged: (_) {
          _promptProvider.searchState;
        },
        onSubmitted: (value) => _promptProvider.addKeyword(keyword: value),
      ),
    );
  }
}