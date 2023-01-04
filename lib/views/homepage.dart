import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(),
              const PromptTextForm(),
            ],
            ),
        ),
      ),
    );
  }
}

class PromptTextForm extends StatefulWidget {
  const PromptTextForm({
    Key? key,
  }) : super(key: key);

  @override
  State<PromptTextForm> createState() => _PromptTextFormState();
}

class _PromptTextFormState extends State<PromptTextForm> {
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: TextField(controller: _textEditingController,),);
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