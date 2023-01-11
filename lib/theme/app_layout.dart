import 'package:flutter/cupertino.dart';

class AppLayout{
  static Widget mainContentLayout({double padding = 20, required Widget child}){
    return Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: child,);
  }
}