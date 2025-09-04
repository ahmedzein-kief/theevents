import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/orders/order_history_model.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key, required this.order});

  final OrderProduct order;

  @override
  _OrderHistoryViewState createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  bool isOrderViewed = false;

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.orderRecord?.statusArr.label ?? '',
                          style: TextStyle(
                            color: _getStatusColor(
                                widget.order.orderRecord?.statusArr.label,),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.order.orderRecord?.createdAt ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.order.orderRecord?.code ?? '',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Product Info
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(widget.order.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.order.orderRecord?.price} for ${widget.order.orderRecord?.total} item(s)',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(
                              orderID:
                                  widget.order.orderRecord?.id.toString() ?? '',
                            ),
                          ),
                        );
                        setState(() {
                          isOrderViewed = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOrderViewed ? Colors.grey : Colors.black,
                      ),
                      child: Text(isOrderViewed
                          ? AppStrings.orderViewed.tr
                          : AppStrings.viewOrder.tr,),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                slug: widget.order.productSlug,),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(AppStrings.viewProduct.tr),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Review Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        _buildCircleAvatar(
                            widget.order.orderRecord?.store.thumb ?? '',),
                        const SizedBox(height: 4),
                        Text(AppStrings.reviewSeller.tr),
                      ],
                    ),
                    Column(
                      children: [
                        _buildCircleAvatar(widget.order.imageThumb ?? ''),
                        const SizedBox(height: 4),
                        Text(AppStrings.reviewProduct.tr),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildCircleAvatar(String imageUrl) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 24, color: Colors.red),
            ),
          ),
        ),
      );
}
