
import 'package:uuid/uuid.dart';

class PromptService{
  
}

enum StyleCategory{
  sketch, effect, color
}
final List<StyleComponent> styleList = [];

class StyleComponent{
  final String styleId = const Uuid().v4();
  final StyleCategory category;
  final String value;
  bool isSelected;

  StyleComponent({required this.category, required this.value}) : isSelected = false;
}

List<StyleComponent> getStyles({required StyleCategory category}){
  return styleList.where((StyleComponent element) => element.category == category,).toList();
}

final List<StyleComponent> selectedStyles = [];

void select(String styleId){
  final found = styleList.where((element) => element.styleId == styleId,);
  if(found.length > 1) throw FoundMultipleIdException("found: ${found.length}");

  found.first.isSelected = true;
}

class FoundMultipleIdException implements Exception{
  final String msg;

  FoundMultipleIdException(this.msg);
  
  @override
  String toString() {
    return super.toString() + msg;
  }
}
