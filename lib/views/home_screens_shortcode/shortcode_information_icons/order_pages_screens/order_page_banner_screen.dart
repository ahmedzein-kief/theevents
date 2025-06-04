import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_status/api_status.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../provider/user_order_provider/order_banner_provider.dart';

class OrderPageBannerScreen extends StatefulWidget {
  const OrderPageBannerScreen({super.key});

  @override
  State<OrderPageBannerScreen> createState() => _OrderPageBannerScreenState();
}

class _OrderPageBannerScreenState extends State<OrderPageBannerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      fetchBannerTopData();
    });
    super.initState();
  }

  Future<void> fetchBannerTopData() async {
    Provider.of<UserOrderProvider>(context, listen: false)
        .fetchOrderBanner(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
                top: screenHeight * 0.02),
            child: Consumer<UserOrderProvider>(
              builder: (BuildContext context, provider, Widget? child) {
                if (provider.apiStatus == ApiStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 0.5,
                    ),
                  );
                } else if (provider.apiStatus == ApiStatus.completed) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4)),
                        height: 100,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: provider.pageData?.coverImage ?? '',
                          height: 100,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                            color: Colors.blueGrey[300], // Background color
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/placeholder.png', // Replace with your actual image path
                                  fit: BoxFit.cover, // Adjust fit if needed
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                ),
                                const CupertinoActivityIndicator(
                                  radius: 16, // Adjust size of the loader
                                  animating: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(provider.pageData?.name ?? 'Orders',
                          style: boldHomeTextStyle()),
                    ],
                  );
                } else if (provider.apiStatus == ApiStatus.error) {
                  return const SizedBox.shrink();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
