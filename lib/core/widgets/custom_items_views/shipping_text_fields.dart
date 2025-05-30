import 'package:flutter/material.dart';

import '../../styles/custom_text_styles.dart';

///    custom card view shipping payment

class CustomFieldSaveCard extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Widget? suffixIcon;
  final String? displayName; // Name of the user, passed from the previous screen
  final ValueChanged<String>? onChanged; // Callback for onChange
  final TextInputType keyboardType; // Property for keyboard style
  final int? maxWords; // New property for the maximum number of words allowed
  final bool isEditable; // New property to control editability
  final String? label; // New property for the static label above the text field

  const CustomFieldSaveCard({
    Key? key,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    required this.focusNode,
    this.nextFocusNode,
    this.displayName,
    this.onChanged, // Accept onChanged as a parameter
    this.keyboardType = TextInputType.text, // Default to text input type
    this.maxWords, // Accept maxWords as a parameter
    this.isEditable = true, // Default to editable
    this.label, // Accept label as an optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If displayName is provided and the controller is empty, set the controller's text
    if (displayName != null && controller.text.isEmpty) {
      controller.text = displayName!;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) // Display the label if provided
            Padding(
              padding: const EdgeInsets.only(bottom: 5), // Add spacing below the label
              child: Text(label!, style: labelHeading(context)),
            ),
          TextField(
            controller: controller,
            // The controller now holds the displayName
            focusNode: focusNode,
            keyboardType: keyboardType,
            // Set the keyboard type
            style: const TextStyle(color: Colors.black),
            // Text color is black
            readOnly: !isEditable,
            // Make the field read-only based on isEditable
            textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
            onSubmitted: (_) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },
            onChanged: (text) {
              // Split the input text into words
              final words = text.trim().split(RegExp(r'\s+')); // Split by whitespace
              if (maxWords != null && words.length > maxWords!) {
                // If the word limit is exceeded, trim the text to the allowed number of words
                controller.text = words.take(maxWords!).join(' ');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length), // Move the cursor to the end
                );
              }
              onChanged?.call(controller.text); // Call onChanged when the text changes
            },
            decoration: InputDecoration(
              hintText: controller.text.isEmpty ? hintText : null,
              // Show hint if controller text is empty
              hintStyle: const TextStyle(color: Colors.grey),
              // Hint text color is grey
              suffixIcon: suffixIcon,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Unfocused border color
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // Focused border color
              ),
              filled: true, // Ensure the background color is applied
            ),
          ),
        ],
      ),
    );
  }
}
