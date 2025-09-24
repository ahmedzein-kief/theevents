import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/fund_expiry_model.dart';
import '../../data/model/fund_expiry_response.dart';
import '../../data/repo/wallet_repository.dart';

part 'fund_expiry_state.dart';

class FundExpiryCubit extends Cubit<FundExpiryState> {
  final WalletRepository _walletRepository;

  FundExpiryCubit(this._walletRepository) : super(FundExpiryInitial());

  Future<void> loadExpiringFunds() async {
    emit(FundExpiryLoading());

    final result = await _walletRepository.getExpiringLots();

    result.fold(
      (failure) => emit(FundExpiryError(failure.message)),
      (response) {
        final funds = response.getAllFunds();
        emit(FundExpiryLoaded(funds, response));
      },
    );
  }

  void filterFunds(String period) {
    if (state is FundExpiryLoaded) {
      final currentState = state as FundExpiryLoaded;
      final filteredFunds = currentState.response.getFundsByPeriod(period);
      emit(FundExpiryLoaded(filteredFunds, currentState.response));
    }
  }
}
