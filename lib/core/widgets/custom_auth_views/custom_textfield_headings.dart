import 'package:flutter/material.dart';

class CustomTextFieldHeadings extends StatelessWidget {
  final title;
  final textView;

  CustomTextFieldHeadings({this.title, this.textView});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14), // Black color for the text
              ),
              TextSpan(
                text: textView,
                style: const TextStyle(color: Colors.red, fontSize: 14), // Red color for the '*'
              ),
            ],
          ),
        ));
  }
}
