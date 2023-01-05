
import 'package:flutter/material.dart';
import 'package:mut_is/services/prompt_service.dart';
import 'package:mut_is/views/homepage.dart';
import 'package:mut_is/views/search_view.dart';
import 'package:provider/provider.dart';

import 'enum/routes.dart';
import 'views/image_list_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PromptProvider>(create: (context) => PromptProvider(),)
    ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: PageRoutes.homepageRoute,
      routes: {
        PageRoutes.homepageRoute :(context) => const HomePage(),
        PageRoutes.searchRoute :(context) => const SearchView(),
      },
    ),
  ));
}
