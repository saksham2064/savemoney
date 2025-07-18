




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------------- Model ---------------------
class GoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final bool isCompleted;
  final int xp;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.isCompleted,
    required this.xp,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map, String docId) {
    return GoalModel(
      id: docId,
      name: map['name'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'] ?? 0.0,
      isCompleted: map['isCompleted'] ?? false,
      xp: map['xp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'isCompleted': isCompleted,
      'xp': xp,
    };
  }
}

// ------------------- Service ---------------------
class GoalService {
  final goalsCollection = FirebaseFirestore.instance.collection('goals');

  Stream<List<GoalModel>> getGoals() {
    return goalsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addGoal(String name, double targetAmount) async {
    final doc = goalsCollection.doc();
    final newGoal = GoalModel(
      id: doc.id,
      name: name,
      targetAmount: targetAmount,
      savedAmount: 0.0,
      isCompleted: false,
      xp: 0,
    );
    await doc.set(newGoal.toMap());
  }

  Future<void> saveProgress(String id, double amount, double currentSaved, double target) async {
    final newSaved = currentSaved + amount;
    final completed = newSaved >= target;
    final xpEarned = completed ? 100 : 10;
    await goalsCollection.doc(id).update({
      'savedAmount': newSaved,
      'isCompleted': completed,
      'xp': FieldValue.increment(xpEarned),
    });
  }
}

// ------------------- UI Screen ---------------------
class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final service = GoalService();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  Future<void> _addGoalDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎯 Add New Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Goal Name")),
            TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Target Amount"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await service.addGoal(_nameController.text.trim(), double.parse(_amountController.text.trim()));
              _nameController.clear();
              _amountController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  String _getBadge(int xp) {
    if (xp >= 200) return "🥇 Gold";
    if (xp >= 100) return "🥈 Silver";
    return "🥉 Bronze";
  }

  double _getProgress(double saved, double target) {
    if (target == 0) return 0;
    return (saved / target).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color.fromARGB(255, 231, 129, 101),
      const Color.fromARGB(255, 237, 185, 51),
      const Color.fromARGB(255, 236, 199, 148),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎮 Your Financial Goals"),
        backgroundColor: colors[0],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoalDialog,
        backgroundColor: colors[1],
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<GoalModel>>(
        stream: service.getGoals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final goals = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: colors[index % colors.length].withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _getProgress(goal.savedAmount, goal.targetAmount),
                        backgroundColor: Colors.white.withOpacity(0.3),
                        color: Colors.white,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Text("Saved Rs. ${goal.savedAmount} / ${goal.targetAmount}", style: const TextStyle(color: Colors.white)),
                      Text("XP: ${goal.xp} → ${_getBadge(goal.xp)}", style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      if (!goal.isCompleted)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () async {
                            await service.saveProgress(goal.id, 100, goal.savedAmount, goal.targetAmount); // Save Rs.100 for demo
                          },
                          child: const Text("Add ₹100 Progress", style: TextStyle(color: Colors.black)),
                        ),
                      if (goal.isCompleted)
                        const Text("✅ Goal Completed!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
