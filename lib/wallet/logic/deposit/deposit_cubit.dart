import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/deposit_method.dart';
import '../../data/repo/wallet_repository.dart';
import 'deposit_state.dart';

class DepositCubit extends Cubit<DepositState> {
  final WalletRepository _repository;

  DepositCubit(this._repository) : super(const DepositState());

  Future<void> loadDepositMethods() async {
    try {
      emit(state.toLoading());
      final methods = await _repository.getDepositMethods();
      emit(state.toLoaded(methods: methods));
    } catch (e) {
      emit(state.toError(e.toString()));
    }
  }

  void selectDepositMethod(DepositMethodType method) {
    if (state.isLoaded) {
      emit(state.copyWith(
        selectedMethod: method,
        amount: 100,
        clearError: true, // Clear any existing errors
      ));
    }
  }

  void updateAmount(double amount) {
    if (state.isLoaded) {
      emit(state.copyWith(
        amount: amount,
        clearError: true, // Clear any existing errors
      ));
    }
  }

  void updateCouponCode(String code) {
    if (state.isLoaded) {
      emit(state.copyWith(
        couponCode: code,
        clearError: true, // Clear any existing errors
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  // Add this method to reset the state back to loaded
  void resetToLoaded() {
    if (state.methods.isNotEmpty) {
      emit(state.copyWith(
        status: DepositStatus.loaded,
        clearError: true,
        // Clear success-related fields
        clearSuccess: true,
      ));
    }
  }

  Future<void> processDeposit() async {
    if (!state.isLoaded) return;

    if (state.selectedMethod == DepositMethodType.giftCard && state.couponCode.isEmpty) {
      emit(state.toError('Please enter a coupon code'));
      return;
    }

    emit(state.toProcessing());

    final result = await _repository.deposit(
      state.selectedMethod!,
      amount: state.amount,
      couponCode: state.couponCode.isNotEmpty ? state.couponCode : null,
    );

    result.fold(
      (failure) => emit(state.toError(failure.message)),
      (deposit) {
        if (deposit.isGiftCardRedeem) {
          emit(state.toGiftCardSuccess(
            deposit: deposit,
            message: deposit.message ?? 'Gift card redeemed successfully!',
            newBalance: deposit.newBalance ?? '0',
            totalCredit: deposit.totalCredit ?? '0',
          ));
        } else if (deposit.isCreditCardPayment) {
          emit(state.toCreditCardSuccess(
            deposit: deposit,
            checkoutUrl: deposit.checkoutUrl!,
            message: deposit.message ?? 'Redirecting to payment gateway...',
          ));
        } else {
          emit(state.toGiftCardSuccess(
            deposit: deposit,
            message: deposit.message ?? 'Deposit completed successfully!',
            newBalance: deposit.newBalance ?? '0',
            totalCredit: deposit.amount ?? '0',
          ));
        }
      },
    );
  }
}
