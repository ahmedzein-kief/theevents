import 'package:equatable/equatable.dart';

import '../../../core/helper/enums/enums.dart';
import '../../data/model/transaction_model.dart';

class HistoryState extends Equatable {
  final List<TransactionModel> transactions;
  final List<TransactionModel> filteredTransactions;
  final TransactionTypeFilter selectedType;
  final MethodFilter selectedMethod;
  final PeriodFilter selectedPeriod;
  final String searchTerm;

  const HistoryState({
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.selectedType = TransactionTypeFilter.all,
    this.selectedMethod = MethodFilter.all,
    this.selectedPeriod = PeriodFilter.days30,
    this.searchTerm = '',
  });

  HistoryState copyWith({
    List<TransactionModel>? transactions,
    List<TransactionModel>? filteredTransactions,
    TransactionTypeFilter? selectedType,
    MethodFilter? selectedMethod,
    PeriodFilter? selectedPeriod,
    String? searchTerm,
  }) {
    return HistoryState(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedType: selectedType ?? this.selectedType,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        filteredTransactions,
        selectedType,
        selectedMethod,
        selectedPeriod,
        searchTerm,
      ];
}
