import 'package:event_app/wallet/logic/wallet/wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/wallet_repository.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit(this._repository) : super(WalletInitial());

  Future<void> loadWalletData() async {
    try {
      emit(WalletLoading());
      final wallet = await _repository.getWalletData();
      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> refreshWallet() async {
    if (state is WalletLoaded) {
      final currentWallet = (state as WalletLoaded).wallet;
      try {
        final updatedWallet = await _repository.getWalletData();
        emit(WalletLoaded(updatedWallet));
      } catch (e) {
        // Keep current state on refresh error
        emit(WalletLoaded(currentWallet));
      }
    }
  }
}
