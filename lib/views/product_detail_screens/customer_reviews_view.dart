import 'package:event_app/models/product_packages_models/customer_reviews_data_response.dart';
import 'package:event_app/models/product_packages_models/product_details_models.dart';
import 'package:flutter/material.dart';

class CustomerReviews extends StatelessWidget {
  const CustomerReviews(
      {super.key, required this.review, required this.customerReviews});
  final Review review;
  final List<CustomerReviewRecord> customerReviews;

  @override
  Widget build(BuildContext context) {
    print(customerReviews.length);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                review.ratingFormatted,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              Text(
                '(${review.reviewsCount})',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < review.reviewsCount ? Colors.amber : Colors.grey,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: review.averageCountArray
                .map(
                  (e) => _buildRatingBar(
                    e.star == 1 ? '${e.star} Star' : '${e.star} Stars',
                    e.percent.toDouble(),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          // Customer Reviews
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Prevents scrolling inside a scrollable parent
            itemCount: customerReviews.length,
            itemBuilder: (context, index) =>
                _buildCustomerReview(customerReviews[index]),
            separatorBuilder: (context, index) => index !=
                    customerReviews.length - 1
                ? const Padding(
                    padding:
                        EdgeInsets.only(left: 60), // Adjust margin as needed
                    child: Divider(
                      height: 0.2,
                      color: Colors.grey,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double progress) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 60,
                child: Text(label, style: const TextStyle(fontSize: 16))),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.amber,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildCustomerReview(CustomerReviewRecord review) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    review.avatarUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${review.createdAtDiffer} Purchased ${review.orderCreatedAt}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < review.star
                                ? Colors.amber
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review.comment,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
