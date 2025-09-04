// import 'package:event_app/views/base_screens/base_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../resources/styles/app_colors.dart';
// import 'signup_screen.dart';
// import 'login_screen.dart';
//
// import 'package:flutter/material.dart';
// import 'signup_screen.dart';
// import 'login_screen.dart';
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page!.toInt();
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screeHeight = MediaQuery.sizeOf(context).height;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body:SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding:    EdgeInsets.only(top: screeHeight*0.099, left: screenWidth*0.05, right: screenWidth*0.05),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      GestureDetector(
//                       onTap: () {
//                         _pageController.animateToPage(1,
//                             duration:  const Duration(milliseconds: 1),
//                             curve: Curves.ease);
//                       },
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('Sign Up',
//                               style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w700,
//                                   color: Theme.of(context).colorScheme.onPrimary)),
//                           if (_currentPage == 1)
//                             AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               margin: const EdgeInsets.only(top: 5),
//                               height: screeHeight * 0.001,
//                               width: screenWidth * 0.3,
//                               color: AppColors.peachyPink,
//                             ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         _pageController.animateToPage(0,
//                             duration:  const Duration(milliseconds: 1),
//                             curve: Curves.ease);
//                       },
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('Sign In',
//                               style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w700,
//                                   color: Theme.of(context).colorScheme.onPrimary
//                               )),
//                           if (_currentPage == 0)
//                             AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               margin: const EdgeInsets.only(top: 5),
//                               height: screeHeight * 0.001,
//                               width: screenWidth * 0.3,
//                               color: AppColors.peachyPink,
//                             ),
//                         ],
//                       ),
//                     ),
//
//
//
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: PageView(
//                   reverse: true,
//                    controller: _pageController,
//                   children:  const [
//                     LoginScreen(),
//                     SignupScreen(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/app_colors.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key, this.initialIndex = 0});

  int initialIndex;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.099,
                        left: screenWidth * 0.0,
                        right: screenWidth * 0.0,),
                    child: TabBar(
                      // indicatorColor: AppColors.peachyPink, // Tab indicator color
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700,),
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.peachyPink, width: 2.0,),),),
                      tabs: [
                        Tab(text: AppStrings.signIn.tr),
                        Tab(text: AppStrings.signUp.tr),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        LoginScreen(),
                        SignupScreen(),
                      ],
                    ),
                  ),
                ],
              ),

              /// back button
              Positioned(
                top: 10,
                left: screenWidth * 0.02,
                right: screenWidth * 0.05,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded),
                      Text(AppStrings.back.tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
