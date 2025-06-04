/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/resources/styles/app_strings.dart';
import 'package:event_app/resources/styles/custom_text_styles.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarVendor extends StatelessWidget implements PreferredSizeWidget {
  final String? imageUrl;
  final String? titleText;
  final String? subtitleText;
  final bool isShowBack;

  CustomAppBarVendor({
    this.isShowBack = false,
    this.imageUrl,
    this.titleText,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/boy.png',
                  width: 40,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleText != null)
                  Text(
                    titleText!,
                    style: vendorName(context),
                  ),
                if (subtitleText != null)
                  Text(
                    subtitleText!,
                    style: vendorJoinDate(context),
                  ),
                 GestureDetector(
                    onTap: () async {
                      */
/*String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                      print(formattedDate); // Example: 2025-02-25 14:30:00
                      var invoice = "Vendor_Agreement_$formattedDate";
                      await generateAgreement(context, invoice);*/ /*

                    },
                    child: Row(
                      children: [
                        Icon(Icons.file_download_outlined, color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 2),
                        Text(AppStrings.vendor_agreement, style: profileItems(context)),

                        // Icon(iconData, color: iconColor, size: iconSize,),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isShowBack)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                CupertinoIcons.clear_thick,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/custom_text_styles.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarVendor extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarVendor({
    super.key,
    this.isShowBack = false,
    this.imageUrl,
    this.titleText,
    this.subtitleText,
    this.onSubtitleTap,
  });
  final String? imageUrl;
  final String? titleText;
  final String? subtitleText;
  final bool isShowBack;
  final VoidCallback? onSubtitleTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/boy.png',
                    width: 40,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titleText != null)
                    Text(
                      titleText!,
                      style: vendorName(context)
                          .copyWith(color: AppColors.semiTransparentBlack),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (subtitleText != null)
                    GestureDetector(
                      onTap: onSubtitleTap,
                      child: Row(
                        children: [
                          Icon(Icons.file_download_outlined,
                              color: Theme.of(context).colorScheme.onPrimary),
                          const SizedBox(width: 2),
                          Text(
                            subtitleText!,
                            style: profileItems(context).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Fixed Clear Button on Right
            if (isShowBack)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    CupertinoIcons.clear_thick,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
