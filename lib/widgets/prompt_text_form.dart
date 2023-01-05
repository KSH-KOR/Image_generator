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
    return TextField(
      maxLines: 10,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter some words or sentences...",
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.4, color: Color(0xFFF76691)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.4, color: Color(0xFFF76691)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      enabled: true,
      controller: PromptProvider.textEditingController,
      onChanged: (_) {
        promptProvider.setSearchState();
      },
      onTap: () => promptProvider.isSearchingMode = true,
      onSubmitted: (value) {
        promptProvider.submitTextField();
      },
    );
  }
}
