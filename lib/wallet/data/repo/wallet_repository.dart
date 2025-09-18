import '../../../core/helper/enums/enums.dart';
import '../model/deposit_method.dart';
import '../model/wallet_model.dart';

abstract class WalletRepository {
  Future<WalletModel> getWalletData();

  Future<bool> addFunds(double amount, DepositMethodType method, {String? couponCode});

  Future<List<DepositMethod>> getDepositMethods();
}

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<WalletModel> getWalletData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return WalletModel(
      currentBalance: 1500.0,
      rewardsEarned: 75.0,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<bool> addFunds(double amount, DepositMethodType method, {String? couponCode}) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // Simulate success/failure
    return true;
  }

  @override
  Future<List<DepositMethod>> getDepositMethods() async {
    return [
      const DepositMethod(
        type: DepositMethodType.giftCard,
        title: 'Gift Card',
        subtitle: 'Redeem your gift card',
        processingInfo: 'No fees',
        isInstant: true,
      ),
      const DepositMethod(
        type: DepositMethodType.creditCard,
        title: 'Credit/Debit Card',
        subtitle: 'Visa, Master Card accepted',
        processingInfo: '2.5% processing fee',
        isInstant: true,
      ),
    ];
  }
}
