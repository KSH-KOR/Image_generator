import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mut_is/views/search_view.dart';
import 'package:provider/provider.dart';

import '../enum/search_states.dart';
import '../services/prompt_service.dart';
import '../widgets/prompt_text_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearched = false;
  
  @override
  void initState() {
    PromptProvider.textEditingController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    PromptProvider.textEditingController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _promptProvider = Provider.of<PromptProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(),
              InkWell(
                onTap: () {
                  _promptProvider.enabled = true;
                  setState(() {
                     _isSearched = true;
                  });
                 
                },
                child: const PromptTextForm(),
              ),
              Visibility(
                visible: _isSearched,
                child: SearchBottomSheet()),
            ],
            ),
        ),
      ),
    );
  }
}



class SearchBottomSheet extends StatelessWidget {
  const SearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);
    switch(promptProvider.searchState){
      case SearchStates.hasNotTyped:
        final recentKeywords = promptProvider.getRecentKeyword();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: recentKeywords.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () => promptProvider.putRecentWordInTheTextField(textToPut: recentKeywords[index].keyword),
                child: Card(
              child: Text(recentKeywords[index].keyword),
            ));
        },);
      case SearchStates.typing:
        final relatedWords = promptProvider.getRelatedWords();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: relatedWords.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => promptProvider.replaceLastWordAfterComma(textToReplace: relatedWords[index]),
              child: Card(
                child: Text(relatedWords[index]),
              ),
            );
        },);
      case SearchStates.afterComma:
        return Container();
    }
  }
}



class AppHeader extends StatelessWidget {
  const AppHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text("Brand Icon & Name"),);
  }
}