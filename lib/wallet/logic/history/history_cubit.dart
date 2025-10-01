import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/enums/enums.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../data/model/transaction_model.dart';
import '../../data/repo/wallet_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final WalletRepository _walletRepository;
  final PdfExportService _pdfExportService;

  HistoryCubit(this._walletRepository, this._pdfExportService) : super(const HistoryState());

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _walletRepository.getTransactions(
      TransactionTypeFilter.all,
      MethodFilter.all,
      PeriodFilter.allTime,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
        transactions: [],
        filteredTransactions: [],
      )),
      (transactionsModel) => emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
        transactions: transactionsModel.transactions,
        filteredTransactions: transactionsModel.transactions,
      )),
    );
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

      // 🔹 Method filter
      bool matchesMethod = true;
      if (state.selectedMethod != MethodFilter.all) {
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

      // 🔹 Period filter
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
          case PeriodFilter.currentMonth:
            cutoffDate = DateTime(now.year, now.month, 1);
            break;
          case PeriodFilter.lastMonth:
            cutoffDate = DateTime(now.year, now.month - 1, 1);
            break;
          case PeriodFilter.currentYear:
            cutoffDate = DateTime(now.year, 1, 1);
            break;
          case PeriodFilter.lastYear:
            cutoffDate = DateTime(now.year - 1, 1, 1);
            break;
          case PeriodFilter.allTime:
            cutoffDate = DateTime(1900);
            break;
        }

        matchesPeriod = tx.date.isAfter(cutoffDate) || tx.date.isAtSameMomentAs(cutoffDate);
      }

      return matchesSearch && matchesType && matchesMethod && matchesPeriod;
    }).toList();

    emit(state.copyWith(filteredTransactions: filtered));
  }

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

  /// Export transactions to PDF
  Future<void> exportTransactions({String? userName, String? customFileName}) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // Get transactions to export (filtered if any filters applied, otherwise all)
      final transactionsToExport =
          state.filteredTransactions.isNotEmpty ? state.filteredTransactions : state.transactions;

      if (transactionsToExport.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No transactions to export',
        ));
        return;
      }

      // Call the export service
      await _pdfExportService.exportTransactionsToPdf(
        transactions: transactionsToExport,
        userName: userName,
        customFileName: customFileName,
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to export transactions: ${e.toString()}',
      ));
    }
  }
}
