


import 'dart:developer';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../enum/search_criteria.dart';
import '../enum/search_states.dart';

class PromptProvider extends ChangeNotifier{
  static TextEditingController? textEditingController;
  String _textInput = '';
  String _textAfterComma = '';
  bool _enabled = false;
  SearchStates _oldState = SearchStates.hasNotTyped;
  final List<KeywordForPrompts> keywordBook = [];
  
  bool get enabled => _enabled;
  String get currTextInput => _textInput;

  String get textAfterCommna => textEditingController!.text.split(',').last;

  SearchStates get searchState{
    SearchStates newState;
    if (textEditingController == null || textEditingController!.text.isEmpty) {
      newState = SearchStates.hasNotTyped;
    } else {
      if(textEditingController!.text.endsWith(' ') || textEditingController!.text.endsWith(',')) {
        newState = SearchStates.afterComma;
      } else {
        newState = SearchStates.typing;
      }
    }
    _oldState = newState;
    notifyListeners();
    return newState;
  }

  void myNotifyListeners() => notifyListeners();

  void initTextEditingController(){
    textEditingController = TextEditingController();
    textEditingController!.addListener(() {searchState;});
  }

  set enabled(bool newVal){
    _enabled = newVal;
    notifyListeners();
  }
  set currTextInput(String newVal){
    _textInput = newVal;
    notifyListeners();
  }
  List<KeywordForPrompts> getRecentKeyword({int n = 10}){
    keywordBook.sort((a, b) => a.lastSearchedTime.microsecond - b.lastSearchedTime.microsecond,);
    n = n > keywordBook.length ? keywordBook.length : n;
    return keywordBook.sublist(0, n);
  }

  List<String> getRelatedWords({String? inTypingText, int n = 12, SearchCriteria criteria = SearchCriteria.startWith}){
    final String targetText = inTypingText ?? textAfterCommna.trim();
    switch(criteria){
      case SearchCriteria.startWith:
        return nouns.where((e) => e.startsWith(targetText),).take(n).toList();
      case SearchCriteria.contains:
        return nouns.where((e) => e.contains(targetText),).take(n).toList();
      case SearchCriteria.containAll:
        return nouns.where((e) {
          for(int i=0; i<targetText.length; i++){
            if(!e.contains(targetText[i])) return false;
          }
          return true;
        }).take(n).toList();
    }
    
  }

  void putRecentWordInTheTextField({required String textToPut}){
    textEditingController!.text = textToPut;
  }

  void replaceLastWordAfterComma({required String textToReplace}){
    if(!textEditingController!.text.contains(',')) {
      textEditingController!.text = textToReplace;
      return;
    }
    int endIndex = textEditingController!.text.length - textAfterCommna.length + 1;
    String a = textEditingController!.text.substring(0, endIndex);
    textEditingController!.text = a + textToReplace;
  }

  void addKeyword({required String keyword}){
    final foundKeywords = findKeywordsByKeywordText(keyword: keyword);
    if(foundKeywords.isNotEmpty){
      _updateKeyword(keywordList: foundKeywords);
    }
    keywordBook.add(KeywordForPrompts.fromKeyword(keyword: keyword));
    notifyListeners();
  }
  void _updateKeyword({String? keywordId, Iterable<KeywordForPrompts>? keywordList}){
    if(keywordId == null && keywordList == null) throw IdAndObjectAreBothNullException("keyword id and keywork object are both null. cannot update keyword");
    if(keywordList != null){
      removeKeyword(keywordList: keywordList);
      addKeyword(keyword: keywordList.first.keyword);
    }
  }
  int? removeKeyword({String? keywordId, Iterable<KeywordForPrompts>? keywordList}){
    if(keywordId == null && keywordList == null) throw IdAndObjectAreBothNullException("keyword id and keywork object are both null. cannot update keyword");
    
    if(keywordId != null){
      keywordBook.removeWhere((element) => element.keywordId.compareTo(keywordId) == 0);
      return 1;
    } else if(keywordList != null){
      for(final keyword in keywordList){
        return removeKeyword(keywordId: keyword.keywordId)! + 1;
      }
    } else{
      return 0;
    }

  }
  Iterable<KeywordForPrompts> findKeywordsByKeywordText({required String keyword}){
    return keywordBook.where((element) => element.keyword.compareTo(keyword) == 0);
  }
  Iterable<KeywordForPrompts> findKeywordsByKeywordId({required String keywordId}){
    return keywordBook.where((element) => element.keywordId.compareTo(keywordId) == 0);
  }
  
}

class KeywordForPrompts{
  final String keyword;
  final DateTime lastSearchedTime;
  final int searchedCount;
  final String keywordId;

  KeywordForPrompts({
    required this.keyword,
    required this.lastSearchedTime,
    required this.searchedCount,
  }) : keywordId = const Uuid().v4();

  factory KeywordForPrompts.fromKeyword({required String keyword}){
    return KeywordForPrompts(keyword: keyword, lastSearchedTime: DateTime.now(), searchedCount: 1);
  }
}

class KeywordBook{
  final List<KeywordForPrompts> keywordBook = [];

  
}

class IdAndObjectAreBothNullException implements Exception{
  final String msg;

  IdAndObjectAreBothNullException(this.msg);

  @override
  String toString() {
    return super.toString() + msg;
  }
}