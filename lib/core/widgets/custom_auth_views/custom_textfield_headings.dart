import 'package:flutter/material.dart';

class CustomTextFieldHeadings extends StatelessWidget {
  const CustomTextFieldHeadings({super.key, this.title, this.textView});
  final title;
  final textView;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,), // Black color for the text
              ),
              TextSpan(
                text: textView,
                style: const TextStyle(
                    color: Colors.red, fontSize: 14,), // Red color for the '*'
              ),
            ],
          ),
        ),
      );
}
