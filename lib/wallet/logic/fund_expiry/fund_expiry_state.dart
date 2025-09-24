part of 'fund_expiry_cubit.dart';

abstract class FundExpiryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FundExpiryInitial extends FundExpiryState {}

class FundExpiryLoading extends FundExpiryState {}

class FundExpiryLoaded extends FundExpiryState {
  final List<FundExpiryModel> funds;
  final FundExpiryResponse response;

  FundExpiryLoaded(this.funds, this.response);

  @override
  List<Object?> get props => [funds, response];
}

class FundExpiryError extends FundExpiryState {
  final String message;

  FundExpiryError(this.message);

  @override
  List<Object?> get props => [message];
}
