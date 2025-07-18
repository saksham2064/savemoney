import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';

class GoalService {
  final CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  Future<DocumentReference> addGoal({
    required String name,
    required double targetAmount,
  }) async {
    return await goalsCollection.add({
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': 0,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateGoalProgress(String goalId, double amountToAdd) async {
    final docRef = goalsCollection.doc(goalId);
    await docRef.update({
      'savedAmount': FieldValue.increment(amountToAdd),
    });
  }

  Future<void> markGoalCompleted(String goalId) async {
    final docRef = goalsCollection.doc(goalId);
    await docRef.update({'completed': true});
  }

  Stream<List<GoalModel>> getGoalsStream() {
    return goalsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GoalModel.fromDoc(doc)).toList());
  }
}
