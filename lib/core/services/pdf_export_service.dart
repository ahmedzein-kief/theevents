import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../wallet/data/model/transaction_model.dart';

class PdfExportService {
  /// Export transactions to PDF
  Future<void> exportTransactionsToPdf({
    required List<TransactionModel> transactions,
    String? userName,
    String? customFileName,
  }) async {
    try {
      final user = userName ?? '';
      final fileName = customFileName ?? 'wallet-transactions-${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';

      // Generate PDF
      final pdf = await _generateTransactionsPdf(user, transactions);

      // Save and share PDF
      final bytes = await pdf.save();
      await _savePdfAndShare(bytes, fileName);
    } catch (e) {
      throw Exception('Failed to export transactions: ${e.toString()}');
    }
  }

  /// Generate PDF document with transactions
  Future<pw.Document> _generateTransactionsPdf(String userName, List<TransactionModel> transactions) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formatter = DateFormat('M/d/yyyy');
    final currencyFormatter = NumberFormat.currency(symbol: 'AED ', decimalDigits: 2);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header Section
            _buildPdfHeader(userName, transactions.length, formatter.format(now)),

            pw.SizedBox(height: 24),

            // Transactions Table
            _buildTransactionsTable(transactions, formatter, currencyFormatter),
          ];
        },
      ),
    );

    return pdf;
  }

  /// Build PDF header section
  pw.Widget _buildPdfHeader(String userName, int transactionCount, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Wallet Transaction History',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Text('Generated on: $date'),
        pw.Text('User: $userName'),
        pw.Text('Total Transactions: $transactionCount'),
      ],
    );
  }

  /// Build transactions table
  pw.Widget _buildTransactionsTable(
    List<TransactionModel> transactions,
    DateFormat formatter,
    NumberFormat currencyFormatter,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FixedColumnWidth(40), // ID
        1: pw.FlexColumnWidth(2), // Transaction Type
        2: pw.FlexColumnWidth(1.5), // Amount
        3: pw.FlexColumnWidth(1.5), // Method
        4: pw.FlexColumnWidth(1.5), // Date
        5: pw.FlexColumnWidth(2), // Status
        6: pw.FlexColumnWidth(1.5), // Reference
        7: pw.FlexColumnWidth(1.5), // Balance
      },
      children: [
        // Header Row
        _buildTableHeaderRow(),

        // Data Rows
        ...transactions.map((transaction) => _buildTransactionRow(transaction, formatter, currencyFormatter)),
      ],
    );
  }

  /// Build table header row
  pw.TableRow _buildTableHeaderRow() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      children: [
        'ID',
        'Transaction Type',
        'Amount',
        'Method',
        'Date',
        'Status',
        'Reference',
        'Balance',
      ].map((header) => _buildTableCell(header, isHeader: true)).toList(),
    );
  }

  /// Build individual transaction row
  pw.TableRow _buildTransactionRow(
    TransactionModel transaction,
    DateFormat formatter,
    NumberFormat currencyFormatter,
  ) {
    return pw.TableRow(
      children: [
        _buildTableCell(transaction.id.toString()),
        _buildTableCell(_getTransactionTypeDisplay(transaction.type)),
        _buildTableCell(currencyFormatter.format(transaction.amount)),
        _buildTableCell(_getMethodDisplay(transaction.method)),
        _buildTableCell(formatter.format(transaction.date)),
        _buildTableCell(_getStatusDisplay(transaction.status)),
        _buildTableCell(transaction.refId ?? 'N/A'),
        _buildTableCell(currencyFormatter.format(transaction.currentBalance)),
      ],
    );
  }

  /// Build table cell
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Save PDF and share with user
  Future<void> _savePdfAndShare(Uint8List bytes, String fileName) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile: Save to temp directory and share
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);

        await SharePlus.instance.share(
          ShareParams(files: [XFile(file.path)], text: 'Transaction History Export'),
        );
      } else {
        // Desktop/Web: Open print dialog
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => bytes,
          name: fileName,
        );
      }
    } catch (e) {
      throw Exception('Failed to save/share PDF: $e');
    }
  }

  /// Format transaction type for display
  String _getTransactionTypeDisplay(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.payment:
        return 'Purchase';
      case TransactionType.reward:
        return 'Reward';
      case TransactionType.refund:
        return 'Refund';
    }
  }

  /// Format payment method for display
  String _getMethodDisplay(PaymentMethod? method) {
    if (method == null) return 'N/A';

    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.purchase:
        return 'Purchase';
      case PaymentMethod.giftCard:
        return 'Gift Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  /// Format transaction status for display
  String _getStatusDisplay(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Complete';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
