import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/custom_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GiftCardBottom extends StatelessWidget {
  const GiftCardBottom({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://theevents.ae/assets/frontend/img/gift_card.webp',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, child, loadingProcessor) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Optional: to round the corners
                    ),
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: 10,
                        animating: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.description.tr,
                  style: headingStyleText(context),
                  softWrap: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    softWrap: true,
                    style: headingDescriptionStyleText(context),
                    AppStrings.descriptionGiftCard.tr,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.termsAndConditions.tr,
                  style: headingStyleText(context),
                  softWrap: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    softWrap: true,
                    style: headingDescriptionStyleText(context),
                    AppStrings.termsAndConditionsText.tr,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  AppStrings.buyAndRedeem.tr,
                  style: headingStyleText(context),
                ),
                const SizedBox(height: 25),
                _buildCircleWithText(
                  context,
                  AppStrings.redeemFirstLine.tr,
                ),
                _buildCircleWithText(
                  context,
                  AppStrings.redeemSecondLine.tr,
                ),
                _buildCircleWithText(
                  context,
                  AppStrings.redeemThirdLine.tr,
                ),
                _buildCircleWithText(
                  context,
                  AppStrings.redeemForthLine.tr,
                ),
                _buildCircleWithText(
                  context,
                  AppStrings.redeemFifthLine.tr,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specifications\nSku : GC-)00001',
                  style: specificationStyleText(context),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildCircleWithText(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: headingDescriptionStyleText(context),
              ),
            ),
          ],
        ),
      );
}
