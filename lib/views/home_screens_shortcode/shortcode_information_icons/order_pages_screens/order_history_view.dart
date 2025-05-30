import 'package:event_app/models/orders/order_history_model.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../product_detail_screens/product_detail_screen.dart';

class OrderHistoryView extends StatefulWidget {
  final OrderProduct order; // Replace `dynamic` with your order model type

  const OrderHistoryView({super.key, required this.order});

  @override
  _OrderHistoryViewState createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  bool isOrderViewed = false; // Example state to track user interaction
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.green;
      case "canceled":
        return Colors.red;
      case "processing":
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        widget.order.orderRecord?.statusArr.label ?? "",
                        style: TextStyle(
                          color: _getStatusColor(widget.order.orderRecord?.statusArr.label),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.order.orderRecord?.createdAt ?? "",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.order.orderRecord?.code ?? "",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Product Information
              Row(
                children: [
                  // Product Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!, // Light stroke color (adjust as needed)
                        width: 2, // Stroke width
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.order.imageUrl), // Replace with actual image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.productName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
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
              SizedBox(height: 16),
              Divider(),
              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      /*setState(() {
                        isOrderViewed = true; // Example state change
                      });*/

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            orderID: widget.order.orderRecord?.id.toString() ?? "",
                          ),
                        ),
                      );
                    },
                    child: Text(isOrderViewed ? 'Order Viewed' : 'View Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOrderViewed ? Colors.grey : Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(slug: widget.order.productSlug),
                        ),
                      );
                    },
                    child: Text('View Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Review Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!, // Light stroke color (adjust as needed)
                            width: 2, // Stroke width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: Image.network(
                              widget.order.orderRecord?.store.thumb ?? "", // Replace with your image URL
                              fit: BoxFit.cover, // Ensures the image covers the CircleAvatar area
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 24, color: Colors.red); // Placeholder in case of error
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Review Seller'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!, // Light stroke color (adjust as needed)
                            width: 2, // Stroke width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: Image.network(
                              widget.order.imageThumb ?? "", // Replace with your image URL
                              fit: BoxFit.cover, // Ensures the image covers the CircleAvatar area
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 24, color: Colors.red); // Placeholder in case of error
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Review Product'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
