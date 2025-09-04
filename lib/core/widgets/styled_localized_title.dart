import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

// Reusable widget for styled localized title
class StyledLocalizedTitle extends StatelessWidget {
  // style for second word

  const StyledLocalizedTitle({
    super.key,
    required this.fullTextKey,
    this.splitWords,
    required this.style1,
    required this.style2,
  });

  final String fullTextKey; // translation key like AppStrings.ourMission
  final List<String>? splitWords; // e.g. ['OUR', 'MISSION']
  final TextStyle style1; // style for first word
  final TextStyle style2;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localizedText = fullTextKey.tr;

    if (locale.languageCode == 'en' &&
        splitWords != null &&
        splitWords!.length == 2) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '${splitWords![0].toUpperCase()} ', style: style1),
            TextSpan(text: splitWords![1].toUpperCase(), style: style2),
          ],
        ),
      );
    } else {
      return Text(
        localizedText,
        style: style1,
      );
    }
  }
}
