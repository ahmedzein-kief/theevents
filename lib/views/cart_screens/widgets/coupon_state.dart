import 'package:flutter/foundation.dart';

@immutable
class CouponState {
  final String code;
  final bool isValid;
  final String message;

  const CouponState({
    required this.code,
    required this.isValid,
    required this.message,
  });

  factory CouponState.empty() => const CouponState(
        code: '',
        isValid: false,
        message: '',
      );

  CouponState copyWith({
    String? code,
    bool? isValid,
    String? message,
  }) {
    return CouponState(
      code: code ?? this.code,
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() => {
        'coupon_code': code,
        'is_valid_coupon': isValid,
        'message': message,
      };

  bool get hasValidCoupon => isValid && code.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponState &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          isValid == other.isValid &&
          message == other.message;

  @override
  int get hashCode => Object.hash(code, isValid, message);

  @override
  String toString() => 'CouponState(code: $code, isValid: $isValid, message: $message)';
}
