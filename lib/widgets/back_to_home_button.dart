

import 'package:flutter/material.dart';

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 73,
          height: 31,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFD9D9D9).withOpacity(0.04),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
              side: BorderSide(width: 1, color: Color(0xFFF76691),)
            ),
            onPressed: Navigator.of(context).pop,
            child: const Text(
              "Home",
              style: TextStyle(
                color: Color(0xFFF76691),
              ),
            ),
          ),
        ),
      ],
    );
  }
}