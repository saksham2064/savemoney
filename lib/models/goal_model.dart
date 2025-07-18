import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final bool completed;
  final DateTime createdAt;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.completed,
    required this.createdAt,
  });

  factory GoalModel.fromDoc(DocumentSnapshot doc) {
  final data = doc.data()! as Map<String, dynamic>;
  return GoalModel(
    id: doc.id,
    name: data['name'] ?? '',
    targetAmount: (data['targetAmount'] ?? 0).toDouble(),
    savedAmount: (data['savedAmount'] ?? 0).toDouble(),
    completed: data['completed'] ?? false,
    createdAt: data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
  );
}


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'completed': completed,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
