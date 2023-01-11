
import 'package:flutter/material.dart';
import 'package:mut_is/services/image_generate_service.dart';
import 'package:mut_is/services/prompt_service.dart';
import 'package:mut_is/views/homepage.dart';
import 'package:provider/provider.dart';

import 'enum/routes.dart';
import 'theme/color_scheme.dart';
import 'views/image_list_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ImageGenerateProvider>(create: (context) => ImageGenerateProvider(),),
      ChangeNotifierProvider<PromptProvider>(create: (context) => PromptProvider(),)
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      initialRoute: PageRoutes.homepageRoute,
      routes: {
        PageRoutes.homepageRoute :(context) => const HomePage(),
        PageRoutes.imageResultRoute : (context) => const ImageListView(),
      },
    ),
  ));
}
