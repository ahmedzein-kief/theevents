import 'dart:io';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/orders/order_detail_model.dart';
import 'package:event_app/provider/orders_provider/order_data_provider.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/pdf_downloader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/padded_network_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderID});

  final String orderID;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    if (!mounted) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      await provider.getOrderDetails(widget.orderID);

      if (mounted) {
        setState(() {
          _isInitializing = false;
          if (provider.orderDetailModel?.data == null) {
            _errorMessage = AppStrings.noOrderDetailsFound.tr;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> uploadProof(String filePath, String fileName) async {
    final provider = Provider.of<OrderDataProvider>(context, listen: false);
    await provider.uploadProof(context, filePath, fileName, widget.orderID);
    // Refresh order details after upload
    if (mounted) {
      await _fetchOrderDetails();
    }
  }

  Future<void> cancelOrder() async {
    if (!mounted) return;
    final provider = Provider.of<OrderDataProvider>(context, listen: false);
    await provider.cancelOrder(context, widget.orderID);
    // Refresh order details after cancellation
    if (mounted) {
      await _fetchOrderDetails();
    }
  }

  Future<void> downloadProof() async {
    if (!mounted) return;

    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.downloadProof(context, widget.orderID);

      if (binaryData == null) {
        if (mounted) {
          AppUtils.showToast(AppStrings.error.tr);
        }
        return;
      }

      final filename = 'Order_Proof_${widget.orderID}';

      if (!mounted) return;

      final result = await PDFDownloader().saveFileInDownloadsUint(context, binaryData, filename);

      if (mounted && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: result.contains(AppStrings.fileSaveError.tr) ? Colors.red : Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.error.tr}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> getInvoice(String orderID, String invoice) async {
    if (!mounted) return;

    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.getInvoice(context, orderID);

      if (binaryData == null) {
        if (mounted) {
          AppUtils.showToast(AppStrings.error.tr);
        }
        return;
      }

      final filename = invoice.endsWith('.pdf') ? invoice.substring(0, invoice.length - 4) : invoice;

      if (!mounted) return;

      await PDFDownloader().saveFileInDownloadsUint(context, binaryData, filename);
    } catch (e) {
      if (mounted) {
        AppUtils.showToast('${AppStrings.error.tr}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      title: AppStrings.orderDetails.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      body: Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Consumer<OrderDataProvider>(
            builder: (context, provider, child) {
              final data = provider.orderDetailModel?.data;

              // Show loading only during initialization or when provider is loading
              if (_isInitializing || (provider.isLoading && data == null)) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                  ),
                );
              }

              // Show error if we have an error message or no data after initialization
              if (_errorMessage != null || data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? Colors.grey.shade400 : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage ?? AppStrings.noOrderDetailsFound.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade300 : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.peachyPink,
                        ),
                        onPressed: _fetchOrderDetails,
                        child: Text(AppStrings.retry.tr),
                      ),
                    ],
                  ),
                );
              }

              // Show the actual order details
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInteractiveSection(
                          isDark: isDark,
                          title: AppStrings.orderInfo.tr,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(isDark, '${AppStrings.orderNumber.tr}:', data.code),
                              _infoRow(isDark, '${AppStrings.time.tr}:', data.createdAt),
                              _infoRow(
                                isDark,
                                '${AppStrings.orderStatus.tr}:',
                                data.status,
                                valueStyle: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        _buildInteractiveSection(
                          isDark: isDark,
                          title: AppStrings.products.tr,
                          content: Column(
                            children: data.products.map((product) => _buildProductRow(isDark, product)).toList(),
                          ),
                        ),
                        _buildInteractiveSection(
                          isDark: isDark,
                          title: AppStrings.charges.tr,
                          content: Column(
                            children: [
                              _infoRow(isDark, '${AppStrings.tax.tr}:', data.taxAmount),
                              _infoRow(isDark, '${AppStrings.discount.tr}:', data.discountAmount),
                              _infoRow(isDark, '${AppStrings.shippingFee.tr}:', data.shippingAmount),
                              Divider(
                                thickness: 1,
                                color: isDark ? Colors.grey.shade700 : Colors.grey[300],
                              ),
                              _infoRow(
                                isDark,
                                '${AppStrings.totalAmount.tr}:',
                                data.totalAmount,
                                valueStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildInteractiveSection(
                          isDark: isDark,
                          title: AppStrings.shippingInfo.tr,
                          content: Column(
                            children: [
                              _infoRow(
                                isDark,
                                AppStrings.shippingStatus.tr,
                                convertHtmlToString(data.shipping.status),
                                valueStyle: const TextStyle(color: Colors.orange, fontSize: 16),
                              ),
                              _infoRow(
                                isDark,
                                AppStrings.dateShipped.tr,
                                convertHtmlToString(data.shipping.dateShipped),
                                valueStyle: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (data.status.toLowerCase() != 'canceled' && data.status.toLowerCase() != 'completed') ...{
                          _buildInteractiveSection(
                            isDark: isDark,
                            title: AppStrings.uploadPaymentProof.tr,
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data.hasUploadedProof)
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: isDark ? Colors.grey.shade300 : Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(text: AppStrings.uploadedProofNote.tr),
                                        TextSpan(text: AppStrings.viewReceipt.tr),
                                        TextSpan(
                                          text: '${data.proofFile}\n\n',
                                          style: const TextStyle(
                                            color: AppColors.lightCoral,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await downloadProof();
                                            },
                                        ),
                                        TextSpan(text: AppStrings.reUploadNote.tr),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    AppStrings.noProofUploaded.tr,
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade300 : Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final File? file = await MediaServices().getSingleFileFromPicker();
                                    if (file != null) {
                                      await uploadProof(file.path, path.basename(file.path));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.upload),
                                  label: Text(AppStrings.uploadButton.tr),
                                ),
                              ],
                            ),
                          ),
                        } else ...{
                          if (data.hasUploadedProof)
                            _buildInteractiveSection(
                              isDark: isDark,
                              title: '',
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade300 : Colors.grey[700],
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(text: AppStrings.uploadedProofNote.tr),
                                    TextSpan(text: AppStrings.viewReceipt.tr),
                                    TextSpan(
                                      text: '${data.proofFile}\n\n',
                                      style: const TextStyle(
                                        color: AppColors.lightCoral,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await downloadProof();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        },
                      ],
                    ),
                  ),
                  if (data.isInvoiceAvailable || data.canBeCanceled)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (data.isInvoiceAvailable)
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    side: const BorderSide(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    final invoice = 'Invoice_${data.code}';
                                    getInvoice(widget.orderID, invoice);
                                  },
                                  child: Text(AppStrings.invoice.tr),
                                ),
                              ),
                            // Uncomment if you want to enable cancel button
                            // const SizedBox(width: 16),
                            // if (data.canBeCanceled)
                            //   Expanded(
                            //     child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //         foregroundColor: Colors.white,
                            //         backgroundColor: Colors.red,
                            //       ),
                            //       onPressed: cancelOrder,
                            //       child: Text(AppStrings.cancel.tr),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  // Show overlay loading indicator when doing operations on existing data
                  if (provider.isLoading)
                    Container(
                      color: Colors.black.withAlpha((0.5 * 255).toInt()),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String convertHtmlToString(String htmlData) {
    final document = parse(htmlData);
    return document.body?.text.trim() ?? '';
  }

  Widget _infoRow(bool isDark, String label, String value, {TextStyle? valueStyle}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : Colors.grey[700],
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: valueStyle ?? TextStyle(color: isDark ? Colors.white : Colors.black),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );

  Widget _buildInteractiveSection({
    required bool isDark,
    required String title,
    required Widget content,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 8),
  }) =>
      Container(
        margin: margin,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty) ...{
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
              },
              content,
            ],
          ),
        ),
      );

  Widget _buildProductRow(bool isDark, OrderDetailProduct product) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: PaddedNetworkBanner(
            imageUrl: product.imageUrl,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            padding: EdgeInsets.zero,
            borderRadius: 0,
          ),
        ),
        title: Text(
          product.productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          '${AppStrings.quantity.tr}: ${product.qty}',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey[700],
          ),
        ),
        trailing: Text(
          product.totalFormat,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
