import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirebaseService {
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  // Get a new document reference with a generated ID
  DocumentReference getTransactionDocRef() {
    return transactionsCollection.doc();
  }

  // Save transaction with specific docRef
  Future<void> saveTransactionWithRef(TransactionModel txn, DocumentReference docRef) async {
    await docRef.set({
      'id': txn.id,
      'type': txn.type,
      'category': txn.category,
      'description': txn.description,
      'amount': txn.amount,
      'date': Timestamp.fromDate(txn.date),
    });
  }

  // Stream transactions sorted by date descending
  Stream<List<TransactionModel>> getTransactionsStream() {
    return transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
