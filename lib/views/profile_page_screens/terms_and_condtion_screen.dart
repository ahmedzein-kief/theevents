// import 'dart:convert';
// import 'dart:developer';
// import 'package:event_app/resources/styles/app_strings.dart';
// import 'package:event_app/utils/apiendpoints/api_end_point.dart';
// import 'package:html/parser.dart' as html_parser;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../../resources/styles/custom_text_styles.dart';
// import '../../resources/widgets/custom_back_icon.dart';
//
// class TermsAndCondtionScreen extends StatefulWidget {
//   const TermsAndCondtionScreen({super.key});
//
//   @override
//   State<TermsAndCondtionScreen> createState() => _TermsAndCondtionScreenState();
// }
//
// class _TermsAndCondtionScreenState extends State<TermsAndCondtionScreen> {
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((callback) {
//       fetchPrivacyPolicy();
//     });
//     super.initState();
//   }
//
//   Future<void> fetchPrivacyPolicy() async {
//     final provider = Provider.of<TermsAndConditionProvider>(context, listen: false);
//     provider.fetchPrivacyPolicy();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Consumer<TermsAndConditionProvider>(
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
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     BackIcon(),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//
//                           Padding(
//                             padding: const EdgeInsets.only(top: 5),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       provider.privacyPolicyData?.name ?? '',
//                                       style: privacyPolicyTextStyle(context),
//                                     ),
//                                        Padding(
//                                       padding: EdgeInsets.only(left: 10),
//                                       child: Icon(
//                                         Icons.article,
//                                         color: Theme.of(context).colorScheme.onPrimary,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Privacy Policy content starts here
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
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
//
//   List<Map<String, String>> _parsePrivacyPolicy(String text) {
//     // Clean the text by removing unwanted HTML entities and characters
//     final cleanedText = text
//         .replaceAll(RegExp(r'&#\d+;'), '') // Remove HTML entities
//         .replaceAll(RegExp(r'[^a-zA-Z0-9\s\.\-:\/]'), ''); // Keep only alphanumeric characters, dots, dashes, etc.
//
//     // Define regex to find sections that start with numbers followed by a dot or dash
//     final sectionRegex = RegExp(r'(\d+[\.\-]\s.*?)(?=\d+[\.\-]\s|$)', dotAll: true);
//
//     // Find all matches based on the regex pattern
//     final matches = sectionRegex.allMatches(cleanedText);
//
//     final sections = <Map<String, String>>[];
//     String initialText = ''; // To capture text before the first section
//
//     if (matches.isNotEmpty) {
//       // Capture initial text before the first section
//       final firstMatch = matches.first;
//       final firstSectionIndex = firstMatch.start;
//       initialText = cleanedText.substring(0, firstSectionIndex).trim();
//
//       // Add initial text as the first section if it's not empty
//       if (initialText.isNotEmpty) {
//         sections.add({'title': 'Introduction', 'description': initialText});
//       }
//     }
//
//     // Parse the rest of the sections
//     for (final match in matches) {
//       final fullMatch = match.group(0) ?? '';
//       final splitIndex = fullMatch.indexOf(':') + 1;
//       final title = fullMatch.substring(0, splitIndex).trim();
//       final description = fullMatch.substring(splitIndex).trim();
//       sections.add({'title': title, 'description': description});
//     }
//
//     log('Parsed Sections: $sections');
//     return sections;
//   }
//
//
//   Widget _buildSection(BuildContext context, Map<String, String> section) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           section['title'] ?? '',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           section['description'] ?? '',
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
//
//
//
// }
//
//
// class TermsAndConditionProvider with ChangeNotifier {
//   TermsConditionsModels? _privacyPolicyData;
//   bool _isLoading = false;
//
//   TermsConditionsModels? get privacyPolicyData => _privacyPolicyData;
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
//         Uri.parse(ApiEndpoints.termsAndConditions));
//
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         _privacyPolicyData = TermsConditionsModels.fromJson(responseBody['data']);
//
//         log('Fetched Content: ${_privacyPolicyData?.content}'); // Log content
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
// void extractContentFromHtml(String htmlContent) {
//     final document = html_parser.parse(htmlContent);
//     final extractedText = document.body?.text ?? '';
//     // Log the raw extracted text
//     log('Extracted Text:-------->$extractedText');
//     _privacyPolicyData?.content = extractedText; // Update the model's content
//     notifyListeners();
//   }
// }
// Html(
//   data: content,
//   style: {
//     "div": Style(
//       margin: Margins.only(bottom: 4.0),
//       lineHeight: LineHeight.number(1.4),
//       whiteSpace: WhiteSpace.normal,
//       padding: HtmlPaddings.zero,
//     ),
//     "p": Style(
//       margin: Margins.only(bottom: 4.0),
//       lineHeight: LineHeight.number(1.4),
//       padding: HtmlPaddings.zero,
//       whiteSpace: WhiteSpace.normal,
//     ),
//     "li": Style(
//       margin: Margins.only(bottom: 4.0),
//       lineHeight: LineHeight.number(1.2),
//       padding: HtmlPaddings.zero,
//       listStyleType: ListStyleType.disc,
//     ),
//     "strong": Style(
//       fontWeight: FontWeight.w900,
//       whiteSpace: WhiteSpace.pre,
//     ),
//   },
// ),


import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/custom_back_icon.dart';
import '../../utils/apiendpoints/api_end_point.dart';

class TermsAndCondtionScreen extends StatefulWidget {
  const TermsAndCondtionScreen({super.key});

  @override
  State<TermsAndCondtionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndCondtionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPrivacyPolicy();
    });
  }

  Future<void> fetchPrivacyPolicy() async {
    final provider = Provider.of<TermsAndConditionProvider>(context, listen: false);
    await provider.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Customize the app bar background color
        leading: BackIcon(),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Consumer<TermsAndConditionProvider>(
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      content,
                      onTapUrl: (url) async {
                        _launchUrl(url);
                        return true;
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

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

class TermsAndConditionProvider with ChangeNotifier {
  TermsConditionsModels? _privacyPolicyData;
  bool _isLoading = false;

  TermsConditionsModels? get privacyPolicyData => _privacyPolicyData;

  bool get isLoading => _isLoading;

  Future<void> fetchPrivacyPolicy() async {
    // if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(ApiEndpoints.termsAndConditions));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _privacyPolicyData = TermsConditionsModels.fromJson(responseBody['data']);
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

class TermsConditionsModels {
  final String? view;
  final String? name;
  final String? slug;
  final String? image;
  final String? coverImage;
  final SeoMeta? seoMeta;
  dynamic content;

  TermsConditionsModels({
    this.view,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.seoMeta,
    this.content,
  });

  factory TermsConditionsModels.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModels(
      view: json['view'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      coverImage: json['cover_image'],
      seoMeta: json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null,
      content: json['content'],
    );
  }
}

class SeoMeta {
  final String? title;
  final String? description;
  final String? image;
  final String? robots;

  SeoMeta({
    this.title,
    this.description,
    this.image,
    this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      robots: json['robots'],
    );
  }
}
