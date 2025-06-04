// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// //
// // class CustomAuthButton extends StatelessWidget {
// //   final String title;
// //   final Function() onPressed;
// //
// //   CustomAuthButton({required this.title, required this.onPressed});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.only(top: 20),
// //       child: GestureDetector(
// //         onTap: onPressed,
// //         child: Container(
// //           width: double.infinity,
// //           height: 50,
// //           alignment: Alignment.center,
// //           decoration:
// //               BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
// //           child: Text(title,
// //               style: GoogleFonts.inter(
// //                   fontSize: 18,
// //                   letterSpacing: 0.2,
// //                    fontStyle: FontStyle.normal,
// //                   textBaseline: TextBaseline.alphabetic,
// //                    color: Theme.of(context).colorScheme.primary,
// //                   fontWeight: FontWeight.w700)),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CustomAuthButton extends StatelessWidget {
//   final String title;
//   final bool isLoading;
//   final Function() onPressed;
//
//   CustomAuthButton({
//     required this.title,
//     this.isLoading = false,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: GestureDetector(
//         onTap: isLoading ? null : onPressed,
//         child: isLoading
//             ? const CircularProgressIndicator(color: Colors.black , strokeWidth: 0.5)
//             : Container(
//                 width: double.infinity,
//                 height: 50,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.onPrimary,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: isLoading
//                     ? CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             Theme.of(context).colorScheme.onPrimary
//                         ),
//                       )
//                     : Text(
//                         title,
//                         style: GoogleFonts.inter(
//                           fontSize: 18,
//                           letterSpacing: 0.2,
//                           fontStyle: FontStyle.normal,
//                           textBaseline: TextBaseline.alphabetic,
//                           color: Theme.of(context).colorScheme.primary,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
  });
  final String title;
  final bool isLoading;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20, // Set width to match the text width
                    height: 20, // Set height to match the text height
                    child: LoadingAnimationWidget.stretchedDots(
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  )
                : Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      letterSpacing: 0.2,
                      fontStyle: FontStyle.normal,
                      textBaseline: TextBaseline.alphabetic,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      );
}
