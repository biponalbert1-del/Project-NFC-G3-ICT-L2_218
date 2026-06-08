import 'package:intl/intl.dart';

String formatTokens(int amount) {
  return NumberFormat.decimalPattern('fr').format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy - HH:mm', 'fr').format(date);
}

String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
