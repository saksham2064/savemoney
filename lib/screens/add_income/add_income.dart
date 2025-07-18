import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../firebase/firebase_service.dart';
import '../../models/transaction_model.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveIncome() async {
    final double? amount = double.tryParse(amountController.text);
    final String category = categoryController.text.trim();
    final String description = descriptionController.text.trim();

    if (amount == null || amount <= 0 || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid amount and category')),
      );
      return;
    }

    // Get new Firestore document reference with generated ID
    final docRef = firebaseService.getTransactionDocRef();

    final txn = TransactionModel(
      id: docRef.id,  // Assign generated ID here
      type: 'income',
      amount: amount,
      category: category,
      description: description,
      date: selectedDate,
    );

    // Save transaction using the document reference
    await firebaseService.saveTransactionWithRef(txn, docRef);

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Income'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                hintText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveIncome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Income',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
