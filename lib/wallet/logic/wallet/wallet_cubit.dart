import 'dart:developer';

import 'package:event_app/wallet/logic/wallet/wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/wallet_model.dart';
import '../../data/repo/wallet_repository.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit(this._repository) : super(WalletInitial());

  WalletModel? walletModel;

  Future<void> loadWalletData() async {
    emit(WalletLoading());
    final result = await _repository.walletOverview();

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) {
        walletModel = wallet;
        emit(WalletLoaded(wallet));
      },
    );
  }

  Future<void> refreshWallet() async {
    // If not loaded, perform initial load instead
    if (state is! WalletLoaded) {
      return loadWalletData();
    }

    final currentWallet = (state as WalletLoaded).wallet;

    emit(WalletLoading());

    await Future.delayed(const Duration(seconds: 1));

    try {
      final result = await _repository.walletOverview();

      result.fold(
        (failure) {
          log('Wallet refresh failed: ${failure.message}');
          // Restore current wallet on failure
          walletModel = currentWallet;
          emit(WalletLoaded(currentWallet));
        },
        (updatedWallet) {
          walletModel = updatedWallet;
          emit(WalletLoaded(updatedWallet));
        },
      );
    } catch (e) {
      log('Wallet refresh exception: $e');
      walletModel = currentWallet;
      emit(WalletLoaded(currentWallet));
    }
  }
}
