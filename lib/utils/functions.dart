import 'package:intl/intl.dart';

String formatAsMoney(double amount) {
  // Create NumberFormat instance for currency formatting
  final NumberFormat formatter =
      NumberFormat.currency(locale: 'en_US', symbol: '₦');

  // Format the amount as currency
  return formatter.format(amount);
}

String formatDate(String isoDate) {
  DateTime dateTime =
      DateTime.parse(isoDate).toLocal(); // Convert to local time
  return DateFormat("MMM d, yyyy, h:mm a").format(dateTime);
}

String formatChatTimestamp(String timestamp) {
  final DateTime messageTime = DateTime.parse(timestamp).toLocal();
  final DateTime now = DateTime.now();

  final isToday = now.year == messageTime.year &&
      now.month == messageTime.month &&
      now.day == messageTime.day;

  final isYesterday = now.year == messageTime.year &&
      now.month == messageTime.month &&
      now.day - 1 == messageTime.day;

  if (isToday) {
    return DateFormat('hh:mm a').format(messageTime); // e.g., 11:25 AM
  } else if (isYesterday) {
    return "Yesterday";
  } else {
    return DateFormat('dd/MM/yyyy').format(messageTime); // e.g., 03/09/2025
  }
}

String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  }

  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  if (!emailRegex.hasMatch(email)) {
    return 'Enter a valid email address';
  }

  return null; // ✅ Valid email
}

String? identifyInput(String input) {
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  // final phoneRegex = RegExp(r'^\+?\d{10,15}$'); // Supports optional +, 10-15 digits

  if (emailRegex.hasMatch(input)) {
    return null;
  }
  // else if (phoneRegex.hasMatch(input)) {
  //   return null;
  // }
  else {
    return 'Enter a valid email address';
  }
}
