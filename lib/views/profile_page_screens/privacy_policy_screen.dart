// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html_parser;
// import 'package:provider/provider.dart';
// import '../../resources/styles/app_strings.dart';
// import '../../resources/styles/custom_text_styles.dart';
// import '../../resources/widgets/custom_back_icon.dart';
//
// class PrivacyPolicyScreen extends StatefulWidget {
//   const PrivacyPolicyScreen({super.key});
//
//   @override
//   State<PrivacyPolicyScreen> createState() => _PrivacyPolicyState();
// }
//
// class _PrivacyPolicyState extends State<PrivacyPolicyScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((callback) {
//       fetchPrivacyPolicy();
//     });
//     super.initState();
//   }
//
//   Future<void> fetchPrivacyPolicy() async {
//     final provider = Provider.of<PrivacyPolicyProvider>(context, listen: false);
//     provider.fetchPrivacyPolicy();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final screenHeight = MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       body: SafeArea(
//         child: Consumer<PrivacyPolicyProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.black,
//                   strokeWidth: 0.5,
//                 ),
//               );
//             }
//
//             final content = provider.privacyPolicyData?.content ?? '';
//
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: screenHeight * 0.01),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         BackIcon(),
//                         SizedBox(height: screenHeight * 0.01),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             left: screenWidth * 0.03,
//                             right: screenWidth * 0.03, ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     provider.privacyPolicyData?.name ?? '',
//                                     style: privacyPolicyTextStyle(context),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: screenWidth * 0.02),
//                                     child: SvgPicture.asset(
//                                         AppStrings.privacyPolicyIcon.tr,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Privacy Policy content starts here
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: screenWidth * 0.03,
//                           right: screenWidth * 0.03,
//                           top: screenHeight * 0.02),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: _parsePrivacyPolicy(content)
//                             .map((section) => _buildSection(context, section))
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   List<Map<String, dynamic>> _parsePrivacyPolicy(String text) {
//     final regex = RegExp(r'(\d+\.\s.*?)(?=\d+\.\s|$)', dotAll: true);
//     final matches = regex.allMatches(text);
//     final sections = <Map<String, dynamic>>[];
//
//     for (final match in matches) {
//       final fullMatch = match.group(0) ?? '';
//       final splitIndex = fullMatch.indexOf(':') + 1;
//
//       final title = fullMatch.substring(0, splitIndex).trim();
//       final description = fullMatch.substring(splitIndex).trim();
//
//       // Extract number and title
//       final number = title.split(' ')[0]; // Extract the number part
//       final sectionTitle =
//           title.substring(title.indexOf(' ') + 1); // Extract the title part
//
//       // Check if the section is special
//       final isSpecial = number == '5' || number == '6' || number == '7';
//
//       sections.add({
//         'number': number,
//         'title': sectionTitle,
//         'description': description,
//         'isSpecial': isSpecial,
//       });
//     }
//
//     return sections;
//   }
//
//   Widget _buildSection(BuildContext context, Map<String, dynamic> section) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Apply a different style based on whether the section is special
//         if (!(section['isSpecial'] as bool)) ...[
//           Text(
//             '${section['number']} ${section['title']}',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold, // Apply bold style
//                 ),
//           ),
//           const SizedBox(height: 8),
//         ] else ...[
//           // For special sections (5, 6, 7), do not print the heading
//           const SizedBox(height: 8),
//         ],
//         Text(
//           section['description'] ?? '',
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/helper/di/locator.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_app_views/default_app_bar.dart';
import '../../core/widgets/custom_back_icon.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      fetchPrivacyPolicy();
    });
  }

  Future<void> fetchPrivacyPolicy() async {
    final provider = Provider.of<PrivacyPolicyProvider>(context, listen: false);
    await provider.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const DefaultAppBar(
        leading: BackIcon(),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Consumer<PrivacyPolicyProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              );
            }

            final content = provider.privacyPolicyData?.content ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            provider.privacyPolicyData?.name ?? AppStrings.privacyPolicy.tr,
                            style: privacyPolicyTextStyle(context),
                          ),
                        ),
                        SvgPicture.asset(
                          AppStrings.privacyPolicyIcon.tr,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Html(
                      data: content,
                      style: {
                        'div': Style(
                          margin: Margins.only(bottom: 4.0),
                          lineHeight: LineHeight.number(1.4),
                          whiteSpace: WhiteSpace.normal,
                          padding: HtmlPaddings.zero,
                        ),
                        'p': Style(
                          margin: Margins.only(bottom: 4.0),
                          lineHeight: LineHeight.number(1.4),
                          padding: HtmlPaddings.zero,
                          whiteSpace: WhiteSpace.normal,
                        ),
                        'li': Style(
                          margin: Margins.only(bottom: 4.0),
                          lineHeight: LineHeight.number(1.2),
                          padding: HtmlPaddings.zero,
                          listStyleType: ListStyleType.disc,
                        ),
                        'strong': Style(
                          fontWeight: FontWeight.w900,
                          whiteSpace: WhiteSpace.pre,
                        ),
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrivacyPolicyProvider with ChangeNotifier {
  PrivacyPolicyModel? _privacyPolicyData;
  bool _isLoading = false;

  PrivacyPolicyModel? get privacyPolicyData => _privacyPolicyData;

  bool get isLoading => _isLoading;

  Future<void> fetchPrivacyPolicy() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await locator.get<Dio>().get(
            ApiEndpoints.privacyPolicy,
          );

      if (response.statusCode == 200) {
        final responseBody = response.data;
        _privacyPolicyData = PrivacyPolicyModel.fromJson(responseBody['data']);
      } else {
        log('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// class PrivacyPolicyProvider with ChangeNotifier {
//   PrivacyPolicyModel? _privacyPolicyData;
//   bool _isLoading = false;
//
//   PrivacyPolicyModel? get privacyPolicyData => _privacyPolicyData;
//
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchPrivacyPolicy() async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await http.get(
//           Uri.parse('https://newapistaging.theevents.ae/api/v1/pages/privacy-policy'));
//
//       if (response.statusCode == 200) {
//         final responseBody = response.data;
//         _privacyPolicyData = PrivacyPolicyModel.fromJson(responseBody['data']);
//
//         extractContentFromHtml(_privacyPolicyData?.content ?? '');
//       } else {
//         log('Failed to load data');
//       }
//     } catch (e) {
//       log('Error fetching data: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void extractContentFromHtml(String htmlContent) {
//     final document = html_parser.parse(htmlContent);
//     final extractedText = document.body?.text ?? '';
//
//     // Here, you can process the extracted text if necessary
//
//     log('Extracted Text:-------->$extractedText');
//     _privacyPolicyData?.content = extractedText; // Update the model's content
//   }
// }

class PrivacyPolicyModel {
  PrivacyPolicyModel({
    this.view,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.seoMeta,
    this.content,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
        view: json['view'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        coverImage: json['cover_image'],
        seoMeta: json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null,
        content: json['content'],
      );
  final String? view;
  final String? name;
  final String? slug;
  final String? image;
  final String? coverImage;
  final SeoMeta? seoMeta;
  dynamic content;
}

class SeoMeta {
  SeoMeta({
    this.title,
    this.description,
    this.image,
    this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  final String? title;
  final String? description;
  final String? image;
  final String? robots;
}
