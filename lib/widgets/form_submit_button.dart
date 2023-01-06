import 'package:flutter/material.dart';
import 'package:mut_is/enum/routes.dart';
import 'package:provider/provider.dart';

import '../services/image_generate_service.dart';
import '../services/prompt_service.dart';

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({super.key});

  void _imageRequest(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: Color(0xFFF76691),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Image is creating...', style:  TextStyle(color: Color(0xFFF76691)),)
                ],
              ),
            ),
          );
        });

    getResponse(request: getRequest(n: 1)).then((response) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(PageRoutes.imageResultRoute, arguments: response);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
        side: BorderSide(width: 1, color: Color(0xFFF76691),)
      ),
      onPressed: () {
        Provider.of<PromptProvider>(context, listen: false).submitTextField();
        OpenAIProvider.prompt = PromptProvider.textEditingController!.text;
        _imageRequest(context);
      },
      child: const Icon(Icons.subdirectory_arrow_left_outlined, color: Color(0xFFF76691),),
    );
  }
}