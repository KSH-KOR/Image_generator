


import 'dart:developer';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../enum/search_criteria.dart';
import '../enum/search_states.dart';

class PromptProvider extends ChangeNotifier{
  static TextEditingController? textEditingController;
  String _finalPromptInput = '';
  String _textAfterComma = '';
  bool _enabled = false;
  SearchStates _oldState = SearchStates.hasNotTyped;
  final List<KeywordForPrompts> keywordBook = [];
  
  bool get isSearchingMode => _enabled;
  String get finalPromptInput => _finalPromptInput;
  set finalPromptInput(newVal) => _finalPromptInput;

  String get textAfterCommna => textEditingController!.text.split(',').last;

  void setSearchState(){
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
  }

  SearchStates get searchState {
    return _oldState;
  } 

  void submitTextField(){
    addKeyword(keyword: textEditingController!.text);
    isSearchingMode = false;
  }

  void cancelSearchingMode(){
    isSearchingMode = false;
  }

  set isSearchingMode(bool newVal){
    _enabled = newVal;
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
      return;
    }
    keywordBook.add(KeywordForPrompts.fromKeyword(keyword: keyword));
  }
  void _updateKeyword({String? keywordId, Iterable<KeywordForPrompts>? keywordList}){
    if(keywordId == null && keywordList == null) throw IdAndObjectAreBothNullException("keyword id and keywork object are both null. cannot update keyword");
    if(keywordList != null){
      String keyword = keywordList.first.keyword;
      removeKeyword(keywordId: keywordList.first.keywordId);
      keywordBook.add(KeywordForPrompts.fromKeyword(keyword: keyword));
    } else{ 
    }
  }
  void removeKeyword({String? keywordId, Iterable<KeywordForPrompts>? keywordList}){
    if(keywordId == null && keywordList == null) throw IdAndObjectAreBothNullException("keyword id and keywork object are both null. cannot update keyword");
    
    if(keywordId != null){
      keywordBook.removeWhere((element) => element.keywordId.compareTo(keywordId) == 0);
    } else if(keywordList != null){
      for(final keyword in keywordList){
        keywordBook.removeWhere((element) => element.keywordId.compareTo(keyword.keywordId) == 0);
      }
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

class IdAndObjectAreBothNullException implements Exception{
  final String msg;

  IdAndObjectAreBothNullException(this.msg);

  @override
  String toString() {
    return super.toString() + msg;
  }
}