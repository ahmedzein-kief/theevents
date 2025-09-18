import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/deposit_method.dart';
import '../../data/repo/wallet_repository.dart';
import 'deposit_state.dart';

class DepositCubit extends Cubit<DepositState> {
  final WalletRepository _repository;

  DepositCubit(this._repository) : super(DepositInitial());

  Future<void> loadDepositMethods() async {
    try {
      emit(DepositMethodsLoading());
      final methods = await _repository.getDepositMethods();
      emit(DepositMethodsLoaded(
        methods: methods,
        selectedMethod: methods.first.type,
      ));
    } catch (e) {
      emit(DepositError(e.toString()));
    }
  }

  void selectDepositMethod(DepositMethodType method) {
    if (state is DepositMethodsLoaded) {
      final currentState = state as DepositMethodsLoaded;
      emit(currentState.copyWith(selectedMethod: method, amount: 100));
    }
  }

  void updateAmount(double amount) {
    if (state is DepositMethodsLoaded) {
      final currentState = state as DepositMethodsLoaded;
      emit(currentState.copyWith(amount: amount));
    }
  }

  void updateCouponCode(String code) {
    if (state is DepositMethodsLoaded) {
      final currentState = state as DepositMethodsLoaded;
      emit(currentState.copyWith(couponCode: code));
    }
  }

  Future<void> processDeposit() async {
    if (state is! DepositMethodsLoaded) return;

    final currentState = state as DepositMethodsLoaded;

    if (currentState.amount <= 0) {
      emit(const DepositError('Please enter a valid amount'));
      return;
    }

    try {
      emit(DepositProcessing());

      final success = await _repository.addFunds(
        currentState.amount,
        currentState.selectedMethod,
        couponCode: currentState.couponCode.isNotEmpty ? currentState.couponCode : null,
      );

      if (success) {
        emit(DepositSuccess(currentState.amount));
      } else {
        emit(const DepositError('Failed to process deposit'));
      }
    } catch (e) {
      emit(DepositError(e.toString()));
    }
  }
}
