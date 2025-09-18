import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/transaction_model.dart';
import '../../logic/drawer/drawer_cubit.dart';
import '../widgets/transaction_item.dart';
import '../widgets/wallet_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'allTypes'.tr;
  String _selectedMethod = 'allMethods'.tr;
  String _selectedPeriod = 'thirtyDays'.tr;
  List<TransactionModel> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _getTransactionHistory();
    _searchController.addListener(_filterTransactions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _getTransactionHistory().where((transaction) {
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = searchTerm.isEmpty || transaction.description.toLowerCase().contains(searchTerm);
        final matchesType = _selectedType == 'allTypes'.tr || _getTypeString(transaction.type) == _selectedType;
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  String _getTypeString(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'deposit'.tr;
      case TransactionType.payment:
        return 'payment'.tr;
      case TransactionType.reward:
        return 'reward'.tr;
      case TransactionType.refund:
        return 'refund'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Balance Cards
            _buildBalanceCards(context),
            // History Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Transaction History title and Export button
                    Row(
                      children: [
                        const Icon(Icons.history, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'transactionHistory'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _exportTransactions,
                          icon: const Icon(
                            Icons.download_outlined,
                            size: 18,
                          ),
                          label: Text(
                            'export'.tr,
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xFF252222),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    _buildSearchBar(context),
                    const SizedBox(height: 16),
                    // Filter Row
                    _buildFilterRow(context),
                    const SizedBox(height: 24),
                    // Transaction List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _filteredTransactions[index];
                          return TransactionItem(transaction: transaction);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'digitalWallet'.tr,
                  style: GoogleFonts.openSans(fontSize: 15),
                ),
                Text(
                  'Hi, Ahmed Al-Mahmoud',
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: const Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'expirySoon'.tr,
              style: GoogleFonts.openSans(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          BlocBuilder<DrawerCubit, bool>(
            builder: (context, isOpen) {
              return IconButton(
                onPressed: () => context.read<DrawerCubit>().toggleDrawer(),
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: WalletCard(
              title: 'currentBalanceTitle'.tr,
              amount: 1500.0,
              currency: 'AED',
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: WalletCard(
              title: 'rewardsEarnedTitle'.tr,
              amount: 75.0,
              currency: 'AED',
              icon: Icons.stars_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'searchTransactions'.tr,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      children: [
        // All Types Dropdown
        Expanded(
          child: _buildDropdown(
            value: _selectedType,
            items: [
              'allTypes'.tr,
              'deposit'.tr,
              'payment'.tr,
              'reward'.tr,
              'refund'.tr,
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
                _filterTransactions();
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // All Methods Dropdown
        Expanded(
          child: _buildDropdown(
            value: _selectedMethod,
            items: [
              'allMethods'.tr,
              'creditCard'.tr,
              'giftCard'.tr,
              'bankTransfer'.tr,
            ],
            onChanged: (value) {
              setState(() {
                _selectedMethod = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // Period Dropdown
        Expanded(
          child: _buildDropdown(
            value: _selectedPeriod,
            items: [
              'thirtyDays'.tr,
              'sevenDays'.tr,
              'ninetyDays'.tr,
              'allTime'.tr,
            ],
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // Reset Button
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('reset'.tr),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(3),
      ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        style: GoogleFonts.openSans(
          fontSize: 11,
          color: const Color(0xFF252525),
        ),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF1E1E1E),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedType = 'allTypes'.tr;
      _selectedMethod = 'allMethods'.tr;
      _selectedPeriod = 'thirtyDays'.tr;
      _searchController.clear();
      _filteredTransactions = _getTransactionHistory();
    });
  }

  void _exportTransactions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('export'.tr),
        backgroundColor: Colors.blue,
      ),
    );
  }

  List<TransactionModel> _getTransactionHistory() {
    return [
      TransactionModel(
        id: '1',
        type: TransactionType.deposit,
        amount: 500.0,
        description: 'giftCardRedemption'.tr,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '2',
        type: TransactionType.refund,
        amount: 500.0,
        description: 'refundCancelled'.tr,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '3',
        type: TransactionType.payment,
        amount: 500.0,
        description: 'purchasedPerfume'.tr,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '4',
        type: TransactionType.deposit,
        amount: 500.0,
        description: 'walletRecharge'.tr,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: TransactionStatus.completed,
      ),
    ];
  }
}
