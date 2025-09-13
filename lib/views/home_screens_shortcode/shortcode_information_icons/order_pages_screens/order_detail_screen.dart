import 'dart:developer';
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

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderID});

  final String orderID;

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _hasInitiallyLoaded = false;
  int _retryCount = 0;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetailsWithRetry(context, widget.orderID);
    });
  }

  Future<void> _fetchOrderDetailsWithRetry(BuildContext? context, String orderID) async {
    if (!mounted || context == null) return;

    final provider = Provider.of<OrderDataProvider>(context, listen: false);

    try {
      await provider.getOrderDetails(context, orderID);
      _hasInitiallyLoaded = true;
      _retryCount = 0;

      // If data is still null after successful API call, it might be a new order
      // Wait a bit and retry for new orders that might not be immediately available
      if (provider.orderDetailModel?.data == null && _retryCount < maxRetries) {
        _retryCount++;
        await Future.delayed(retryDelay);
        if (mounted) {
          _fetchOrderDetailsWithRetry(context, orderID);
        }
      }
    } catch (e) {
      _hasInitiallyLoaded = true;
      // Handle error case
    }
  }

  Future<void> uploadProof(
    String filePath,
    String fileName,
  ) async {
    final provider = Provider.of<OrderDataProvider>(context, listen: false);
    provider.uploadProof(context, filePath, fileName, widget.orderID);
  }

  Future<void> fetchOrderDetails(BuildContext? context, String orderID) async {
    if (!mounted) return;
    final provider = Provider.of<OrderDataProvider>(context!, listen: false);
    await provider.getOrderDetails(context, orderID);
  }

  Future<void> cancelOrder(BuildContext? context, String orderID) async {
    if (!mounted) return;
    final provider = Provider.of<OrderDataProvider>(context!, listen: false);
    await provider.cancelOrder(context, orderID);
  }

  // Replace your existing downloadProof method in OrderDetailsScreen:
  Future<void> downloadProof(BuildContext? context) async {
    if (!mounted || context == null) return;

    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.downloadProof(context, widget.orderID);

      if (binaryData == null) {
        if (mounted && context.mounted) {
          AppUtils.showToast(AppStrings.error.tr);
        }
        return;
      }

      final filename = 'Order_Proof_${widget.orderID}';

      // Use the correct method that accepts Uint8List
      final result = await PDFDownloader().saveFileInDownloadsUint(context, binaryData, filename);

      if (mounted && context.mounted && result != null) {
        log('result $result');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: result.contains(AppStrings.fileSaveError.tr) ? Colors.red : Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error downloading proof: $e');
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.error.tr}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

// Replace your existing getInvoice method in OrderDetailsScreen:
  Future<void> getInvoice(
    BuildContext? context,
    String orderID,
    String invoice,
  ) async {
    if (!mounted || context == null) return;

    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.getInvoice(context, orderID);

      if (binaryData == null) {
        if (mounted && context.mounted) {
          AppUtils.showToast(AppStrings.error.tr);
        }
        return;
      }

      final filename = invoice.endsWith('.pdf') ? invoice.substring(0, invoice.length - 4) : invoice;
      await PDFDownloader().saveFileInDownloadsUint(context, binaryData, filename);
    } catch (e) {
      if (mounted && context.mounted) {
        AppUtils.showToast('${AppStrings.error.tr}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) => BaseAppBar(
        textBack: AppStrings.back.tr,
        title: AppStrings.orderDetails.tr,
        customBackIcon: const Icon(
          Icons.arrow_back_ios_sharp,
          size: 16,
        ),
        body: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Consumer<OrderDataProvider>(
              builder: (context, provider, child) {
                final data = provider.orderDetailModel?.data;

                // Show loading indicator when loading OR when we haven't initially loaded yet
                if (provider.isLoading || !_hasInitiallyLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.peachyPink,
                      ),
                    ),
                  );
                }

                // Only show error state if we have initially loaded and still no data
                if (data == null && _hasInitiallyLoaded) {
                  // Show error state or empty state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _retryCount >= maxRetries ? AppStrings.noOrderDetailsFound.tr : AppStrings.loading.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_retryCount >= maxRetries)
                          ElevatedButton(
                            onPressed: () {
                              _retryCount = 0;
                              _hasInitiallyLoaded = false;
                              _fetchOrderDetailsWithRetry(context, widget.orderID);
                            },
                            child: Text(AppStrings.retry.tr),
                          ),
                      ],
                    ),
                  );
                }

                return Stack(
                  children: [
                    // Main Content
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInteractiveSection(
                            title: AppStrings.orderInfo.tr,
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow(
                                  '${AppStrings.orderNumber.tr}:',
                                  data!.code,
                                ),
                                _infoRow(
                                  '${AppStrings.time.tr}:',
                                  data.createdAt,
                                ),
                                _infoRow(
                                  '${AppStrings.orderStatus.tr}:',
                                  data.status,
                                  valueStyle: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                          _buildInteractiveSection(
                            title: AppStrings.products.tr,
                            content: Column(
                              children: data.products.map((product) => _buildProductRow(product)).toList(),
                            ),
                          ),
                          _buildInteractiveSection(
                            title: AppStrings.charges.tr,
                            content: Column(
                              children: [
                                _infoRow(
                                  '${AppStrings.tax.tr}:',
                                  data.taxAmount,
                                ),
                                _infoRow(
                                  '${AppStrings.discount.tr}:',
                                  data.discountAmount,
                                ),
                                _infoRow(
                                  '${AppStrings.shippingFee.tr}:',
                                  data.shippingAmount,
                                ),
                                Divider(thickness: 1, color: Colors.grey[300]),
                                _infoRow(
                                  '${AppStrings.totalAmount.tr}:',
                                  data.totalAmount,
                                  valueStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildInteractiveSection(
                            title: AppStrings.shippingInfo.tr,
                            content: Column(
                              children: [
                                _infoRow(
                                  AppStrings.shippingStatus.tr,
                                  convertHtmlToString(data.shipping.status),
                                  valueStyle: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                  ),
                                ),
                                _infoRow(
                                  AppStrings.dateShipped.tr,
                                  convertHtmlToString(
                                    data.shipping.dateShipped,
                                  ),
                                  valueStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (data.status.toLowerCase() != 'canceled' && data.status.toLowerCase() != 'completed') ...{
                            _buildInteractiveSection(
                              title: AppStrings.uploadPaymentProof.tr,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data.hasUploadedProof)
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: AppStrings.uploadedProofNote.tr,
                                          ),
                                          TextSpan(
                                            text: AppStrings.viewReceipt.tr,
                                          ),
                                          TextSpan(
                                            text: '${data.proofFile}\n\n',
                                            style: const TextStyle(
                                              color: AppColors.lightCoral,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                await downloadProof(context);
                                              },
                                          ),
                                          TextSpan(
                                            text: AppStrings.reuploadNote.tr,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Text(
                                      AppStrings.noProofUploaded.tr,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final File? file = await MediaServices().getSingleFileFromPicker();
                                      if (file != null) {
                                        uploadProof(
                                          file.path,
                                          path.basename(file.path),
                                        );
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
                                title: '',
                                content: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: AppStrings.uploadedProofNote.tr,
                                      ),
                                      TextSpan(
                                        text: AppStrings.viewReceipt.tr,
                                      ),
                                      TextSpan(
                                        text: '${data.proofFile}\n\n',
                                        style: const TextStyle(
                                          color: AppColors.lightCoral,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await downloadProof(context);
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

                    // Bottom Buttons
                    if (data.isInvoiceAvailable || data.canBeCanceled)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
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
                                      getInvoice(
                                        context,
                                        widget.orderID,
                                        invoice,
                                      );
                                    },
                                    child: Text(AppStrings.invoice.tr),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              if (data.canBeCanceled)
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showCancelConfirmationDialog(context);
                                    },
                                    child: Text(AppStrings.cancel.tr),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    // Loading overlay for subsequent operations (when data exists)
                    if (provider.isLoading && _hasInitiallyLoaded && data != null)
                      Container(
                        color: Colors.black.withAlpha((0.5 * 255).toInt()), // Semi-transparent background
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.peachyPink,
                            ),
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

  String convertHtmlToString(String htmlData) {
    final document = parse(htmlData);
    return document.body?.text.trim() ?? ''; // Extract plain text
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            Text(
              value,
              style: valueStyle ?? const TextStyle(color: Colors.black),
            ),
          ],
        ),
      );

  Widget _buildInteractiveSection({
    required String title,
    required Widget content,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 8),
  }) =>
      Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
              },
              content,
            ],
          ),
        ),
      );

  Widget _buildProductRow(OrderDetailProduct product) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 80,
              width: 80,
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          product.productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${AppStrings.quantity.tr}: ${product.qty}'),
        trailing: Text(
          product.totalFormat,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          AppStrings.confirmation.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Make text bold
            fontSize: 18, // Optional: Set font size
          ),
        ),
        content: Text(AppStrings.confirmationMessage.tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lightCoral, // Set text color for "No"
            ),
            child: Text(
              AppStrings.no.tr,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              cancelOrder(context, widget.orderID);
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lightCoral, // Set text color for "Yes"
            ),
            child: Text(
              AppStrings.yes.tr,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
