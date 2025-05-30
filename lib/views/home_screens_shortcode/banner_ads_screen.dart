import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/navigation/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/home_shortcode_provider/banner_ads_provider.dart';

class BannerAdsScreen extends StatefulWidget {
  final dynamic data;

  const BannerAdsScreen({super.key, required this.data});

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
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
                  child: CachedNetworkImage(
                    imageUrl: provider.homeBannerModels?.data?.tabletImageUrl ?? '',
                    fit: BoxFit.fill,
                    height: 100,
                    width: double.infinity,
                    errorWidget: (context, child, loadingProcessor) {
                      return Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12), // Optional: to round the corners
                        ),
                        child: const Center(
                          child: CupertinoActivityIndicator(color: Colors.black, radius: 10, animating: true),
                        ),
                      );
                    },
                    errorListener: (object){
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12), // Optional: to round the corners
                        ),
                      );
                    },
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
