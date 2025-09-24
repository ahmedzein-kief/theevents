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
    if (state is WalletLoaded) {
      final currentWallet = (state as WalletLoaded).wallet;
      try {
        final result = await _repository.walletOverview();

        result.fold(
          (failure) => emit(WalletError(failure.message)),
          (updatedWallet) {
            walletModel = updatedWallet;
            emit(WalletLoaded(updatedWallet));
          },
        );
      } catch (e) {
        walletModel = currentWallet;
        // Keep current state on refresh error
        emit(WalletLoaded(currentWallet));
      }
    }
  }
}
