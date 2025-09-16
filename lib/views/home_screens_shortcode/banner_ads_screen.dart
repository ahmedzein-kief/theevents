import 'package:event_app/core/router/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/widgets/padded_network_banner.dart';
import '../../provider/home_shortcode_provider/banner_ads_provider.dart';

class BannerAdsScreen extends StatefulWidget {
  const BannerAdsScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<BannerAdsScreen> createState() => _ApplyBannerState();
}

class _ApplyBannerState extends State<BannerAdsScreen> {
  Future<void> fetchHomeBannerData() async {
    final provider = Provider.of<BannerAdsProvider>(context, listen: false);
    await provider.fetchHomeBanner(context, data: widget.data);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHomeBannerData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<BannerAdsProvider>(
      builder: (context, provider, child) {
        if (provider.homeBannerModels != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, right: 10, left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.newProduct,
                    arguments: {
                      'key1': 'value1',
                      'key2': 'value2',
                    },
                  );
                },
                child: SizedBox(
                  width: screenWidth,
                  child: PaddedNetworkBanner(
                    imageUrl: provider.homeBannerModels?.data?.tabletImageUrl ?? ApiConstants.placeholderImage,
                    fit: BoxFit.cover,
                    height: screenHeight * 0.14,
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    borderRadius: 0,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
