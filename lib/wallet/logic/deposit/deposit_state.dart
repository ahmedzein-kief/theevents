import 'package:equatable/equatable.dart';

import '../../../core/helper/enums/enums.dart';
import '../../data/model/deposit_method.dart';

abstract class DepositState extends Equatable {
  const DepositState();

  @override
  List<Object?> get props => [];
}

class DepositInitial extends DepositState {}

class DepositMethodsLoading extends DepositState {}

class DepositMethodsLoaded extends DepositState {
  final List<DepositMethod> methods;
  final DepositMethodType selectedMethod;
  final double amount;
  final String couponCode;

  const DepositMethodsLoaded({
    required this.methods,
    required this.selectedMethod,
    this.amount = 0.0,
    this.couponCode = '',
  });

  DepositMethodsLoaded copyWith({
    List<DepositMethod>? methods,
    DepositMethodType? selectedMethod,
    double? amount,
    String? couponCode,
  }) {
    return DepositMethodsLoaded(
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      amount: amount ?? this.amount,
      couponCode: couponCode ?? this.couponCode,
    );
  }

  @override
  List<Object?> get props => [methods, selectedMethod, amount, couponCode];
}

class DepositProcessing extends DepositState {}

class DepositSuccess extends DepositState {
  final double amount;

  const DepositSuccess(this.amount);

  @override
  List<Object?> get props => [amount];
}

class DepositError extends DepositState {
  final String message;

  const DepositError(this.message);

  @override
  List<Object?> get props => [message];
}
