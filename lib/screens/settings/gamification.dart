import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MoneyTask {
  final String id;
  final String task;
  final String type;
  final double amount;
  final String person;
  final String dueDate;
  final String status;
  final String notes;

  MoneyTask({
    required this.id,
    required this.task,
    required this.type,
    required this.amount,
    required this.person,
    required this.dueDate,
    required this.status,
    required this.notes,
  });

  factory MoneyTask.fromMap(Map<String, dynamic> map, String id) {
    return MoneyTask(
      id: id,
      task: map['task'],
      type: map['type'],
      amount: map['amount'],
      person: map['person'],
      dueDate: map['dueDate'],
      status: map['status'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'type': type,
      'amount': amount,
      'person': person,
      'dueDate': dueDate,
      'status': status,
      'notes': notes,
    };
  }
}

class MoneyTodoScreen extends StatefulWidget {
  const MoneyTodoScreen({super.key});

  @override
  State<MoneyTodoScreen> createState() => _MoneyTodoScreenState();
}

class _MoneyTodoScreenState extends State<MoneyTodoScreen> {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('money_tasks');

  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _amountController = TextEditingController();
  final _personController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'Payable';
  String _status = 'Pending';

  void _addTask() async {
    if (_formKey.currentState!.validate()) {
      final task = MoneyTask(
        id: const Uuid().v4(),
        task: _taskController.text,
        type: _type,
        amount: double.tryParse(_amountController.text) ?? 0,
        person: _personController.text,
        dueDate: _dueDateController.text,
        status: _status,
        notes: _notesController.text,
      );
      await taskCollection.doc(task.id).set(task.toMap());

      _taskController.clear();
      _amountController.clear();
      _personController.clear();
      _dueDateController.clear();
      _notesController.clear();
      setState(() {
        _type = 'Payable';
        _status = 'Pending';
      });
    }
  }

  Stream<List<MoneyTask>> getTasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MoneyTask.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> deleteTask(String id) async {
    await taskCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("💸 Money To-Do List")),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: ExpansionTile(
              title: const Text("➕ Add New Task"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _taskController,
                        decoration: const InputDecoration(labelText: 'Task'),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter task' : null,
                      ),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _personController,
                        decoration: const InputDecoration(labelText: 'Person'),
                      ),
                      TextFormField(
                        controller: _dueDateController,
                        decoration: const InputDecoration(labelText: 'Due Date'),
                      ),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                      DropdownButton<String>(
                        value: _type,
                        onChanged: (val) => setState(() => _type = val!),
                        items: ['Payable', 'Receivable', 'Purchase']
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addTask,
                        child: const Text("Add Task"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "📝 Task List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MoneyTask>>(
              stream: getTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tasks = snapshot.data!;
                if (tasks.isEmpty) {
                  return const Center(child: Text("No tasks yet."));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final t = tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(t.task),
                        subtitle: Text(
                            '${t.type} • Rs.${t.amount} • ${t.status} • Due: ${t.dueDate}\n${t.notes}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(t.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

