import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  final String id;
  final String type;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      type: map['type'] ?? 'expense',
      category: map['category'] ?? 'Other',
      description: map['description'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      date: (map['date'] as Timestamp).toDate(), // ✅ Converts Firestore Timestamp to DateTime
    );
  }

  String formattedDate() {
    try {
      return DateFormat('dd/MM/yyyy').format(date); // ✅ Requires intl
    } catch (e) {
      return 'Invalid date';
    }
  }
}
