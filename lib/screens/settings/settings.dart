// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: FinancialGoalsGamificationPage(),
//   ));
// }

// class FinancialGoalsGamificationPage extends StatefulWidget {
//   const FinancialGoalsGamificationPage({Key? key}) : super(key: key);

//   @override
//   _FinancialGoalsGamificationPageState createState() =>
//       _FinancialGoalsGamificationPageState();
// }

// class _FinancialGoalsGamificationPageState
//     extends State<FinancialGoalsGamificationPage> {
//   final List<Goal> goals = [
//     Goal(
//       name: 'Save Money',
//       progress: 0,
//       targetDate: DateTime.now().add(const Duration(days: 10)),
//     ),
//     Goal(
//       name: 'Create a Budget',
//       progress: 0,
//       targetDate: DateTime.now().add(const Duration(days: 15)),
//     ),
//     Goal(
//       name: 'Invest in Stocks',
//       progress: 0,
//       targetDate: DateTime.now().add(const Duration(days: 30)),
//     ),
//   ];

//   final TextEditingController _goalController = TextEditingController();
//   DateTime? _selectedDate;

//   void _incrementProgress(int index) {
//     setState(() {
//       if (goals[index].progress < 100) {
//         goals[index].progress += 20;
//         if (goals[index].progress > 100) {
//           goals[index].progress = 100;
//         }
//       }
//     });
//   }

//   Future<void> _pickDate(BuildContext context) async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? now,
//       firstDate: now,
//       lastDate: DateTime(now.year + 5),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _addGoal() {
//     final text = _goalController.text.trim();
//     if (text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a goal name')),
//       );
//       return;
//     }

//     if (_selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a target date')),
//       );
//       return;
//     }

//     setState(() {
//       goals.add(Goal(name: text, targetDate: _selectedDate!));
//       _goalController.clear();
//       _selectedDate = null;
//     });
//   }

//   String _timeLeft(Goal goal) {
//     final now = DateTime.now();
//     if (goal.targetDate.isBefore(now)) return 'Expired';

//     final diff = goal.targetDate.difference(now);
//     final days = diff.inDays;
//     final hours = diff.inHours % 24;
//     final minutes = diff.inMinutes % 60;

//     if (days > 0) {
//       return '$days day${days > 1 ? 's' : ''} left';
//     } else if (hours > 0) {
//       return '$hours hour${hours > 1 ? 's' : ''} left';
//     } else {
//       return '$minutes min${minutes > 1 ? 's' : ''} left';
//     }
//   }

//   @override
//   void dispose() {
//     _goalController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat.yMMMd();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Financial Goals Gamification'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         color: Colors.blue[50],
//         child: Column(
//           children: [
//             // Add Goal input + date picker + button
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: TextField(
//                     controller: _goalController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter a new goal',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: InkWell(
//                     onTap: () => _pickDate(context),
//                     child: Container(
//                       height: 54,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade400),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         _selectedDate == null
//                             ? 'Select Date'
//                             : dateFormat.format(_selectedDate!),
//                         style: TextStyle(
//                           color: _selectedDate == null
//                               ? Colors.grey.shade600
//                               : Colors.black87,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: _addGoal,
//                   child: const Text('Add Goal'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Goals list
//             Expanded(
//               child: goals.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No goals yet. Add one above!',
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: goals.length,
//                       itemBuilder: (context, index) {
//                         final goal = goals[index];
//                         final isComplete = goal.progress >= 100;
//                         final isExpired = goal.targetDate.isBefore(DateTime.now());

//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16, horizontal: 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         goal.name,
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           decoration: isExpired
//                                               ? TextDecoration.lineThrough
//                                               : null,
//                                           color: isExpired ? Colors.red : null,
//                                         ),
//                                       ),
//                                     ),
//                                     if (isComplete)
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 4),
//                                         decoration: BoxDecoration(
//                                           color: Colors.green,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.green.withOpacity(0.6),
//                                               blurRadius: 8,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: const Text(
//                                           'Completed',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   'Target: ${dateFormat.format(goal.targetDate)} — ${_timeLeft(goal)}',
//                                   style: TextStyle(
//                                     color: isExpired ? Colors.red : Colors.black87,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 LinearProgressIndicator(
//                                   value: goal.progress / 100,
//                                   backgroundColor: Colors.grey[300],
//                                   color: Colors.amber,
//                                   minHeight: 16,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('${goal.progress} % completed'),
//                                     ElevatedButton(
//                                       onPressed: (isComplete || isExpired)
//                                           ? null
//                                           : () => _incrementProgress(index),
//                                       child: const Text('Complete Step'),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: (isComplete || isExpired)
//                                             ? Colors.grey
//                                             : Colors.blueAccent,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Goal {
//   final String name;
//   int progress;
//   final DateTime targetDate;

//   Goal({
//     required this.name,
//     required this.targetDate,
//     this.progress = 0,
//   });
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinancialGoalsGamificationPag extends StatelessWidget {
  const FinancialGoalsGamificationPag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set Goal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wallet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Manage"),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 90,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: const [
                        Color.fromARGB(255, 231, 129, 101),
                        Color.fromARGB(255, 237, 185, 51),
                        Color.fromARGB(255, 236, 199, 148),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 40,
                        color: Colors.white,
                      ),
                      Text("Cash", style: TextStyle(color: Colors.white)),
                      Text("Rs 32423", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 99, 98, 98),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(CupertinoIcons.add, size: 40)],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Budget",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Manage"),
              ],
            ),
            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.add),
                    ),
                    SizedBox(width: 5),
                    Text("Add Budget"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Goal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Manage"),
              ],
            ),
            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.add),
                    ),
                    SizedBox(width: 5),
                    Text("Add Goal"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Debt",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Manage"),
              ],
            ),
            SizedBox(height: 10),


            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.add),
                    ),
                    SizedBox(width: 5),
                    Text("Add Debt"),
                  ],
                ),
              ),
            ),
SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recurring",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Manage"),
              ],
            ),
            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.add),
                    ),
                    SizedBox(width: 5),
                    Text("Add Recurring"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
