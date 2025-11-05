class Formatters {
  static String formatCurrency(double amount, {String currency = 'AED'}) {
    return '$currency ${amount.toStringAsFixed(2)}';
  }

  static String formatDateTime(DateTime dateTime) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final month = months[dateTime.month - 1];

    // Universal format: Day Month Year, Time (works for both LTR and RTL)
    return '$month ${dateTime.day}, ${dateTime.year} ${hour == 0 ? 12 : hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  static String formatDate(DateTime dateTime) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[dateTime.month - 1];
    return '${dateTime.day} $month ${dateTime.year}';
  }

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}
