import 'dart:io';

import 'package:event_app/models/orders/order_detail_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/common_data_response.dart';
import 'package:event_app/provider/orders_provider/order_data_provider.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/pdf_downloader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderID;

  const OrderDetailsScreen({super.key, required this.orderID});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrderDetails(context, widget.orderID);
    });
  }

  Future<CommonDataResponse?> uploadProof(String filePath, String fileName) async {
    final provider = Provider.of<OrderDataProvider>(context, listen: false);
    var response = await provider.uploadProof(context, filePath, fileName, widget.orderID);
    return response;
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

  Future<void> downloadProof(BuildContext? context) async {
    if (!mounted) return;
    if (context == null) return;
    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.downloadProof(context, widget.orderID);
      var filename = "Order_Proof_${widget.orderID}";

      // Save binary data as a PDF
      final result = await PDFDownloader().saveFileInDownloads(context, binaryData!, filename);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    } finally {}
  }

  Future<void> getInvoice(BuildContext? context, String orderID, String invoice) async {
    if (!mounted) return;
    if (context == null) return;
    try {
      final provider = Provider.of<OrderDataProvider>(context, listen: false);
      final binaryData = await provider.getInvoice(context, orderID);
      var filename = invoice;

      // Save binary data as a PDF
      final result = await PDFDownloader().saveFileInDownloads(context, binaryData!, filename);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      textBack: 'Back',
      title: "Order Details",
      customBackIcon: const Icon(
        Icons.arrow_back_ios_sharp,
        size: 16,
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Consumer<OrderDataProvider>(
          builder: (context, provider, child) {
            var data = provider.orderDetailModel?.data;

            /*if (provider.isLoading)
              return Center(
                child: SizedBox(
                  width: 50, // Set the desired width
                  height: 50, // Set the desired height
                  child: const CircularProgressIndicator(color: Colors.black),
                ),
              );
            else {*/
            if (data != null) {
              return Stack(
                children: [
                  // Main Content
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInteractiveSection(
                          title: 'Order Info',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow('Order number:', data.code),
                              _infoRow('Time:', data.createdAt),
                              _infoRow(
                                'Order status:',
                                data.status,
                                valueStyle: TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        _buildInteractiveSection(
                          title: 'Products',
                          content: Column(
                            children: data.products.map((product) => _buildProductRow(product)).toList(),
                          ),
                        ),
                        _buildInteractiveSection(
                          title: 'Charges',
                          content: Column(
                            children: [
                              _infoRow('Tax:', data.taxAmount),
                              _infoRow('Discount:', data.discountAmount),
                              _infoRow('Shipping fee:', data.shippingAmount),
                              Divider(thickness: 1, color: Colors.grey[300]),
                              _infoRow(
                                'Total Amount:',
                                data.totalAmount,
                                valueStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildInteractiveSection(
                          title: 'Shipping Info',
                          content: Column(
                            children: [
                              _infoRow(
                                'Shipping Status:',
                                convertHtmlToString(data.shipping.status),
                                valueStyle: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                              _infoRow(
                                'Date shipped:',
                                convertHtmlToString(data.shipping.dateShipped),
                                valueStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (data.status.toLowerCase() != "canceled" && data.status.toLowerCase() != "completed") ...{
                          _buildInteractiveSection(
                            title: 'Upload Payment Proof',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                data.hasUploadedProof
                                    ? RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.grey[700], fontSize: 16),
                                          children: [
                                            TextSpan(text: "You have uploaded a copy of your payment proof.\n\n"),
                                            TextSpan(
                                              text: "View Receipt: ",
                                            ),
                                            TextSpan(
                                              text: "${data.proofFile}\n\n",
                                              style: TextStyle(color: AppColors.lightCoral, fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  await downloadProof(context);
                                                },
                                            ),
                                            TextSpan(text: "Or you can upload a new one, the old one will be replaced."),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        'The order is currently being processed. For expedited processing, kindly upload a copy of your payment proof:',
                                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                                      ),
                                SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    File? file = await MediaServices().getSingleFileFromPicker();
                                    if (file != null) {
                                      final result = await uploadProof(file.path, path.basename(file.path));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: Icon(Icons.upload),
                                  label: Text('Upload Payment Proof'),
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
                                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                                    children: [
                                      TextSpan(text: "You have uploaded a copy of your payment proof.\n\n"),
                                      TextSpan(
                                        text: "View Receipt: ",
                                      ),
                                      TextSpan(
                                        text: "${data.proofFile}\n\n",
                                        style: TextStyle(color: AppColors.lightCoral, fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await downloadProof(context);
                                          },
                                      ),
                                    ],
                                  ),
                                ))
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
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (data.isInvoiceAvailable)
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    var invoice = "Invoice_${data.code}";
                                    getInvoice(context, widget.orderID, invoice);
                                  },
                                  child: Text('Invoice'),
                                ),
                              ),
                            SizedBox(width: 16),
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
                                  child: Text('Cancel'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if (provider.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent background
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return Container();
            }
            // }
          },
        ),
      ),
    );
  }

  String convertHtmlToString(String htmlData) {
    var document = parse(htmlData);
    return document.body?.text.trim() ?? ''; // Extract plain text
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
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
            style: valueStyle ?? TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSection({
    required String title,
    required Widget content,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 8),
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
            },
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(OrderDetailProduct product) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.imageUrl,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        product.productName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Quantity: ${product.qty}'),
      trailing: Text(
        product.totalFormat,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmation',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make text bold
              fontSize: 18, // Optional: Set font size
            ),
          ),
          content: Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.lightCoral, // Set text color for "No"
              ),
              child: Text(
                'No',
                style: TextStyle(fontSize: 16),
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
                'Yes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
