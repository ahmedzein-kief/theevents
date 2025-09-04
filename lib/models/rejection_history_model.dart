// ===== UPDATED DATA MODELS FOR YOUR API RESPONSE =====

/// Model for individual rejection history items
class RejectionHistoryModel {
  final int id;
  final int productId;
  final int rejectedById;
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSubmitted;
  final String rejectedByUser;

  RejectionHistoryModel({
    required this.id,
    required this.productId,
    required this.rejectedById,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.isSubmitted,
    required this.rejectedByUser,
  });

  factory RejectionHistoryModel.fromJson(Map<String, dynamic> json) {
    return RejectionHistoryModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      rejectedById: json['rejected_by'] ?? 0,
      reason: json['reason'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      isSubmitted: (json['is_submitted'] ?? 0) == 1,
      rejectedByUser: json['rejectedByUser'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'rejected_by': rejectedById,
      'reason': reason,
      'rejectedByUser': rejectedByUser,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_submitted': isSubmitted ? 1 : 0,
    };
  }

  String get submissionStatus {
    return isSubmitted ? 'Submitted' : 'Not Submitted';
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}, '
        "${createdAt.hour.toString().padLeft(2, '0')}:"
        "${createdAt.minute.toString().padLeft(2, '0')}:"
        "${createdAt.second.toString().padLeft(2, '0')} "
        "${createdAt.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  String toString() {
    return 'RejectionHistoryModel{id: $id, productId: $productId, rejectedByUser: $rejectedByUser, reason: $reason}';
  }
}

/// Model for the complete API response
class RejectionHistoryResponse {
  final bool error;
  final RejectionHistoryData data;
  final String? message;

  RejectionHistoryResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory RejectionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RejectionHistoryResponse(
      error: json['error'] ?? false,
      data: RejectionHistoryData.fromJson(json['data'] ?? {}),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
      'message': message,
    };
  }

  bool get isSuccess => !error;

  bool get hasHistory => data.history.isNotEmpty;

  List<RejectionHistoryModel> get history => data.history;
}

/// Model for the data section of the API response
class RejectionHistoryData {
  final List<RejectionHistoryModel> history;

  RejectionHistoryData({
    required this.history,
  });

  factory RejectionHistoryData.fromJson(Map<String, dynamic> json) {
    final historyList = json['history'] as List<dynamic>? ?? [];
    return RejectionHistoryData(
      history: historyList
          .map((item) =>
              RejectionHistoryModel.fromJson(item as Map<String, dynamic>),)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history': history.map((item) => item.toJson()).toList(),
    };
  }

  int get totalRejections => history.length;

  RejectionHistoryModel? get latestRejection =>
      history.isNotEmpty ? history.first : null;

  List<RejectionHistoryModel> get submittedRejections =>
      history.where((item) => item.isSubmitted).toList();

  List<RejectionHistoryModel> get notSubmittedRejections =>
      history.where((item) => !item.isSubmitted).toList();
}

/// Updated service implementation to work with the new models
abstract class RejectionHistoryService {
  Future<RejectionHistoryResponse> getRejectionHistory(String productId);

  Future<bool> submitRejection({
    required String productId,
    required String reason,
    required String rejectedBy,
  });
}

/// Concrete implementation of the service
class RejectionHistoryServiceImpl implements RejectionHistoryService {
  final String baseUrl;
  final Map<String, String> headers;
  final Duration timeout;

  RejectionHistoryServiceImpl({
    required this.baseUrl,
    this.headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.timeout = const Duration(seconds: 30),
  });

  @override
  Future<RejectionHistoryResponse> getRejectionHistory(String productId) async {
    try {
      // Replace with your actual HTTP implementation
      final response =
          await _makeHttpRequest('GET', '/rejection-history/$productId');

      if (response.statusCode == 200) {
        final jsonData = _parseJsonResponse(response.body);
        return RejectionHistoryResponse.fromJson(jsonData);
      } else {
        throw RejectionHistoryException(
          'Failed to load rejection history',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is RejectionHistoryException) {
        rethrow;
      }
      throw RejectionHistoryException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<bool> submitRejection({
    required String productId,
    required String reason,
    required String rejectedBy,
  }) async {
    try {
      final response = await _makeHttpRequest(
        'POST',
        '/rejection-history/$productId',
        body: {
          'reason': reason,
          'rejected_by': rejectedBy,
        },
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      throw RejectionHistoryException(
          'Failed to submit rejection: ${e.toString()}',);
    }
  }

  // Mock methods - replace with your actual HTTP implementation
  Future<HttpResponse> _makeHttpRequest(String method, String endpoint,
      {Map<String, dynamic>? body,}) async {
    throw UnimplementedError('Replace with your HTTP client implementation');
  }

  Map<String, dynamic> _parseJsonResponse(String responseBody) {
    throw UnimplementedError('Replace with your JSON parsing implementation');
  }
}

/// Custom exception class
class RejectionHistoryException implements Exception {
  final String message;
  final int? statusCode;

  RejectionHistoryException(this.message, {this.statusCode});

  @override
  String toString() => 'RejectionHistoryException: $message';
}

/// Mock HTTP response class
class HttpResponse {
  final int statusCode;
  final String body;

  HttpResponse({required this.statusCode, required this.body});
}
