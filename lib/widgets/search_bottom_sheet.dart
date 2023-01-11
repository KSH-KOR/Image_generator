
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum/search_states.dart';
import '../services/image_generate_service.dart';
import '../services/prompt_service.dart';

class SearchBottomSheet extends StatelessWidget {
  const SearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
     log(OpenAIProvider.apiKey!);
    switch(Provider.of<PromptProvider>(context).searchState){
      case SearchStates.hasNotTyped:
        final recentKeywords = promptProvider.getRecentKeyword();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: recentKeywords.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => promptProvider.putRecentWordInTheTextField(
                  textToPut: recentKeywords[index].keyword),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(recentKeywords[index].keyword, style: const TextStyle(color: Color(0xFFF76691)),),
              ),
            );
          },
        );
      case SearchStates.typing:
        final relatedWords = promptProvider.getRelatedWords();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: relatedWords.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => promptProvider.replaceLastWordAfterComma(
                  textToReplace: relatedWords[index]),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(relatedWords[index], style: const TextStyle(color: Color(0xFFF76691)),),
              ),
            );
          },
        );
      case SearchStates.afterComma:
        return Container();
    }
  }
}
