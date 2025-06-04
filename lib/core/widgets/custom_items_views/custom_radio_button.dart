import 'package:flutter/material.dart';

// class CustomCheckboxRadioWidget extends StatefulWidget {
//   final String text;
//   final String imageUrl;
//   final bool isChecked;
//   final ValueChanged<bool> onChanged;
//
//   CustomCheckboxRadioWidget({
//     required this.text,
//     required this.imageUrl,
//     required this.isChecked,
//     required this.onChanged,
//   });
//
//   @override
//   _CustomCheckboxRadioWidgetState createState() => _CustomCheckboxRadioWidgetState();
// }
//
// class _CustomCheckboxRadioWidgetState extends State<CustomCheckboxRadioWidget> {
//   @override
//   Widget build(BuildContext context) {
//     dynamic screenWidth = MediaQuery.sizeOf(context).width;
//     dynamic screenHeight = MediaQuery.sizeOf(context).height;
//     return Padding(
//       padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.06,vertical: screenWidth * 0.04),
//       child: Column(
//         children: [
//           Row(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   widget.onChanged(!widget.isChecked); // Toggle checked state
//                 },
//                 child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.black, // Border color
//                       width: 1, // Border width
//                     ),
//                   ),
//                   child: widget.isChecked
//                       ? Center(
//                     child: Container(
//                       width: 12.0,
//                       height: 12.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black, // Inner filled circle when checked
//                       ),
//                     ),
//                   )
//                       : null, // Empty when unchecked
//                 ),
//               ),
//               SizedBox(width: screenWidth * 0.02), // Space between checkbox and text
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.text,
//                       style: TextStyle(fontSize: 16), // Customize text style as needed
//                     ),
//                     Image.asset(
//                       widget.imageUrl,
//                       width: 24,
//                       height: 24,
//                     ), // Image asset display
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//         ],
//
//       ),
//     );
//   }
// }

class CustomRadioListTile extends StatelessWidget {
  // Image URL

  const CustomRadioListTile({
    super.key,
    required this.titleText,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.imageUrl,
  });
  final String titleText;
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic> onChanged;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: Text(
              titleText,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight
                      .w300), // You can replace with your style (VendorAuth)
            ),
            activeColor: Colors.black,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
        if (imageUrl != null)
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: Image.network(
              imageUrl!, // Display the image next to the text
              width: 40,
              height: 40,
            ),
          ),
      ],
    );
  }
}
