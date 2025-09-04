import 'package:flutter/cupertino.dart';

import '../styles/app_colors.dart';

class ItemsEmptyView extends StatefulWidget {
  const ItemsEmptyView({super.key});

  @override
  State<ItemsEmptyView> createState() => _ItemsEmptyViewState();
}

class _ItemsEmptyViewState extends State<ItemsEmptyView> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
                top: screenHeight * 0.02,),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.lightCoral),
              height: 50,
              child: const Align(
                  alignment: Alignment.center,
                  child: Text('No records found!'),),
            ),
          ),
        ],
      ),
    );
  }
}
