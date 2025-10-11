import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsSection extends StatelessWidget {
  const TermsSection({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            AppStrings.termsNote.tr,
            style: GoogleFonts.lato(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsAndCondtionScreen(),
              ),
            ),
            child: Text(
              AppStrings.readOurTermsAndConditions.tr,
              style: GoogleFonts.lato(
                color: Colors.blue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
