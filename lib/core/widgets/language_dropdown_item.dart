import 'package:event_app/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LanguageDropdownItem extends StatefulWidget {
  const LanguageDropdownItem({super.key});

  @override
  State<LanguageDropdownItem> createState() => _LanguageDropdownItemState();
}

class _LanguageDropdownItemState extends State<LanguageDropdownItem> {
  @override
  void initState() {
    super.initState();
    // Fetch languages when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      localeProvider.fetchLanguages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 👇 This ensures widget rebuilds on locale change
    Localizations.localeOf(context); // triggers rebuild

    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/Language.svg',
            width: 21,
            height: 21,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn,),
          ),
          const SizedBox(width: 16),
          if (localeProvider.isLoadingLanguages)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            DropdownButton<String>(
              value: currentLocale,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              items: localeProvider.languages.map((language) {
                return DropdownMenuItem(
                  value: language.code,
                  child: Text(
                    '${language.flag ?? '🌐'} ${language.name ?? language.code}',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              }).toList(),
              onChanged: (String? langCode) {
                if (langCode != null) {
                  localeProvider.setLocale(Locale(langCode));
                }
              },
            ),
        ],
      ),
    );
  }
}
