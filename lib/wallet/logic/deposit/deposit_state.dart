import 'package:equatable/equatable.dart';

import '../../data/model/deposit_method.dart';
import '../../data/model/deposit_model.dart';

enum DepositStatus {
  initial,
  loading,
  loaded,
  processing,
  success,
}

class DepositState extends Equatable {
  final DepositStatus status;
  final List<DepositMethod> methods;
  final DepositMethodType? selectedMethod;
  final double amount;
  final String couponCode;
  final String? errorMessage;
  final DepositModel? deposit;
  final String? checkoutUrl;
  final String? successMessage;
  final String? newBalance;
  final String? totalCredit;

  const DepositState({
    this.status = DepositStatus.initial,
    this.methods = const [],
    this.selectedMethod,
    this.amount = 0.0,
    this.couponCode = '',
    this.errorMessage,
    this.deposit,
    this.checkoutUrl,
    this.successMessage,
    this.newBalance,
    this.totalCredit,
  });

  // Convenience getters
  bool get isInitial => status == DepositStatus.initial;

  bool get isLoading => status == DepositStatus.loading;

  bool get isLoaded => status == DepositStatus.loaded;

  bool get isProcessing => status == DepositStatus.processing;

  bool get isSuccess => status == DepositStatus.success;

  bool get hasError => errorMessage != null;

  bool get isGiftCardSuccess => isSuccess && checkoutUrl == null;

  bool get isCreditCardSuccess => isSuccess && checkoutUrl != null;

  DepositState copyWith({
    DepositStatus? status,
    List<DepositMethod>? methods,
    DepositMethodType? selectedMethod,
    double? amount,
    String? couponCode,
    String? errorMessage,
    DepositModel? deposit,
    String? checkoutUrl,
    String? successMessage,
    String? newBalance,
    String? totalCredit,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return DepositState(
      status: status ?? this.status,
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      amount: amount ?? this.amount,
      couponCode: couponCode ?? this.couponCode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deposit: clearSuccess ? null : (deposit ?? this.deposit),
      checkoutUrl: clearSuccess ? null : (checkoutUrl ?? this.checkoutUrl),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      newBalance: clearSuccess ? null : (newBalance ?? this.newBalance),
      totalCredit: clearSuccess ? null : (totalCredit ?? this.totalCredit),
    );
  }

  // Factory methods for common state changes
  DepositState toLoading() => copyWith(status: DepositStatus.loading, clearError: true);

  DepositState toLoaded({
    required List<DepositMethod> methods,
    DepositMethodType? selectedMethod,
  }) =>
      copyWith(
        status: DepositStatus.loaded,
        methods: methods,
        selectedMethod: selectedMethod ?? methods.first.type,
        clearError: true,
        clearSuccess: true,
      );

  DepositState toProcessing() => copyWith(status: DepositStatus.processing, clearError: true);

  DepositState toError(String message) => copyWith(errorMessage: message);

  // Add this method to reset back to loaded state
  DepositState resetToLoaded() => copyWith(
        status: DepositStatus.loaded,
        clearError: true,
        clearSuccess: true,
      );

  DepositState toGiftCardSuccess({
    required DepositModel deposit,
    required String message,
    required String newBalance,
    required String totalCredit,
  }) =>
      copyWith(
        status: DepositStatus.success,
        deposit: deposit,
        successMessage: message,
        newBalance: newBalance,
        totalCredit: totalCredit,
        clearError: true,
      );

  DepositState toCreditCardSuccess({
    required DepositModel deposit,
    required String checkoutUrl,
    required String message,
  }) =>
      copyWith(
        status: DepositStatus.success,
        deposit: deposit,
        checkoutUrl: checkoutUrl,
        successMessage: message,
        clearError: true,
      );

  @override
  List<Object?> get props => [
        status,
        methods,
        selectedMethod,
        amount,
        couponCode,
        errorMessage,
        deposit,
        checkoutUrl,
        successMessage,
        newBalance,
        totalCredit,
      ];
}
