import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/helper/di/locator.dart';
import '../../core/network/api_endpoints/api_end_point.dart';
import '../../core/widgets/custom_app_views/default_app_bar.dart';
import '../../core/widgets/custom_back_icon.dart';

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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: const DefaultAppBar(
          leading: BackIcon(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
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
      final response = await locator.get<Dio>().get(ApiEndpoints.termsAndConditions);

      if (response.statusCode == 200) {
        final responseBody = response.data;
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
  TermsConditionsModels({
    this.view,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.seoMeta,
    this.content,
  });

  factory TermsConditionsModels.fromJson(Map<String, dynamic> json) => TermsConditionsModels(
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
