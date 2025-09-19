import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/enums/enums.dart';
import '../../data/model/transaction_model.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState()) {
    loadTransactions();
  }

  void loadTransactions() {
    final transactions = _mockTransactionHistory();
    emit(state.copyWith(
      transactions: transactions,
      filteredTransactions: transactions,
    ));
  }

  void updateSearch(String searchTerm) {
    emit(state.copyWith(searchTerm: searchTerm));
    _applyFilters();
  }

  void updateType(TransactionTypeFilter type) {
    emit(state.copyWith(selectedType: type));
    _applyFilters();
  }

  void updateMethod(MethodFilter method) {
    emit(state.copyWith(selectedMethod: method));
    _applyFilters();
  }

  void updatePeriod(PeriodFilter period) {
    emit(state.copyWith(selectedPeriod: period));
    _applyFilters();
  }

  void resetFilters() {
    emit(state.copyWith(
      selectedType: TransactionTypeFilter.all,
      selectedMethod: MethodFilter.all,
      selectedPeriod: PeriodFilter.days30,
      searchTerm: '',
      filteredTransactions: state.transactions,
    ));
  }

  void _applyFilters() {
    final search = state.searchTerm.toLowerCase();

    final filtered = state.transactions.where((tx) {
      // 🔹 Search filter
      final matchesSearch = search.isEmpty || tx.description.toLowerCase().contains(search);

      // 🔹 Type filter
      final matchesType =
          state.selectedType == TransactionTypeFilter.all || _mapTypeToFilter(tx.type) == state.selectedType;

      // 🔹 Method filter - IMPROVED with direct field comparison
      bool matchesMethod = true;
      if (state.selectedMethod != MethodFilter.all) {
        log('selectedMethod: ${state.selectedMethod}');
        switch (state.selectedMethod) {
          case MethodFilter.creditCard:
            matchesMethod = tx.method == PaymentMethod.creditCard;
            break;
          case MethodFilter.giftCard:
            matchesMethod = tx.method == PaymentMethod.giftCard;
            break;
          case MethodFilter.bankTransfer:
            matchesMethod = tx.method == PaymentMethod.bankTransfer;
            break;
          case MethodFilter.all:
            matchesMethod = true;
            break;
        }
      }

      // 🔹 Period filter - FIXED logic
      bool matchesPeriod = true;
      if (state.selectedPeriod != PeriodFilter.allTime) {
        final now = DateTime.now();
        DateTime cutoffDate;

        switch (state.selectedPeriod) {
          case PeriodFilter.days7:
            cutoffDate = now.subtract(const Duration(days: 7));
            break;
          case PeriodFilter.days30:
            cutoffDate = now.subtract(const Duration(days: 30));
            break;
          case PeriodFilter.days90:
            cutoffDate = now.subtract(const Duration(days: 90));
            break;
          case PeriodFilter.allTime:
            cutoffDate = DateTime(1900); // Very old date
            break;
        }

        // Transaction must be AFTER the cutoff date to be included
        matchesPeriod = tx.date.isAfter(cutoffDate) || tx.date.isAtSameMomentAs(cutoffDate);
      }

      return matchesSearch && matchesType && matchesMethod && matchesPeriod;
    }).toList();

    emit(state.copyWith(filteredTransactions: filtered));
  }

  // 🔹 Helper method to map TransactionType to TransactionTypeFilter
  TransactionTypeFilter _mapTypeToFilter(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return TransactionTypeFilter.deposit;
      case TransactionType.payment:
        return TransactionTypeFilter.payment;
      case TransactionType.reward:
        return TransactionTypeFilter.reward;
      case TransactionType.refund:
        return TransactionTypeFilter.refund;
    }
  }

  // 🔹 Updated Mock Data with PaymentMethod field
  List<TransactionModel> _mockTransactionHistory() => [
        // Recent gift card redemption
        TransactionModel(
          id: '1',
          type: TransactionType.deposit,
          amount: 500.0,
          description: 'Gift Card Redemption - Events Gift Card',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          status: TransactionStatus.completed,
          method: PaymentMethod.giftCard,
        ),

        // Bank transfer refund from yesterday
        TransactionModel(
          id: '2',
          type: TransactionType.refund,
          amount: 500.0,
          description: 'Refund - Cancelled City Perfume Order',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: TransactionStatus.completed,
          method: PaymentMethod.bankTransfer,
        ),

        // Credit card purchase from 2 days ago
        TransactionModel(
          id: '3',
          type: TransactionType.payment,
          amount: 500.0,
          description: 'Purchased Gissah Perfume',
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: TransactionStatus.completed,
          method: PaymentMethod.creditCard,
        ),

        // Additional test data for better filtering demonstration
        TransactionModel(
          id: '4',
          type: TransactionType.reward,
          amount: 50.0,
          description: 'Loyalty Points Reward',
          date: DateTime.now().subtract(const Duration(days: 5)),
          status: TransactionStatus.completed,
          method: null, // Some transactions might not have a payment method
        ),

        // Old transaction (beyond 30 days) for period filter testing
        TransactionModel(
          id: '5',
          type: TransactionType.payment,
          amount: 250.0,
          description: 'Old Purchase - Test Product',
          date: DateTime.now().subtract(const Duration(days: 45)),
          status: TransactionStatus.completed,
          method: PaymentMethod.creditCard,
        ),

        // Credit card transaction within 7 days
        TransactionModel(
          id: '6',
          type: TransactionType.payment,
          amount: 150.0,
          description: 'Recent Credit Card Purchase',
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: TransactionStatus.completed,
          method: PaymentMethod.creditCard,
        ),
      ];
}
