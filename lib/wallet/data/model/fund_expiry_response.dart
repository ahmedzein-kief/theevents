import 'fund_expiry_model.dart';

class FundExpiryResponse {
  final bool status;
  final String message;
  final Map<String, List<FundExpiryModel>> data;

  const FundExpiryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FundExpiryResponse.fromJson(Map<String, dynamic> json) {
    final dataMap = <String, List<FundExpiryModel>>{};

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is List) {
          dataMap[key] = value.map((item) => FundExpiryModel.fromJson(item)).toList();
        }
      });
    }

    return FundExpiryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: dataMap,
    );
  }

  // Get all funds as a flat list
  List<FundExpiryModel> getAllFunds() {
    final allFunds = <FundExpiryModel>[];
    for (final funds in data.values) {
      allFunds.addAll(funds);
    }
    return allFunds;
  }

  // Get funds by expiry period
  List<FundExpiryModel> getFundsByPeriod(String period) {
    return data[period] ?? [];
  }
}
