import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_form.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../provider/information_icons_provider/gift_card_provider.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardInnerScreenState();
}

class _GiftCardInnerScreenState extends State<GiftCardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGiftCardPage();
    });
  }

  Future<void> fetchGiftCardPage() async {
    final provider = Provider.of<GiftCardInnerProvider>(context, listen: false);
    provider.createGiftCardPage(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(
          child: Consumer<GiftCardInnerProvider>(
            builder: (context, giftCardProvider, _) {
              if (giftCardProvider.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.4,
                  ),
                );
              }

              if (giftCardProvider.error != null) {
                return Center(child: Text(giftCardProvider.error!));
              }

              final data = giftCardProvider.apiResponse?.data;

              if (data == null) {
                return const Center(child: Text('No data available'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    hintText: 'Search ${data.name}',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GiftCardHeader(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              data: data,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(title, style: boldHomeTextStyle()),
                                  Text(data.name, style: boldHomeTextStyle()),
                                ],
                              ),
                            ),
                            const GiftCardForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
