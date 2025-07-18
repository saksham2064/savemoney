import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../add_expense/add_expense.dart';
import '../add_income/add_income.dart';
import '../add_loan/add_loan.dart';
import '../main/main_screen.dart';
import '../stats/stat_screen.dart';
import '../profile/profile.dart';
import '../settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> widgetList = [
    const MainScreen(),
    const StatScreen(),
    const FinancialGoalsGamificationPage(),
    const ProfileScreen(),
  ];

  void _openAddDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.add, color: Colors.green),
              title: const Text('Add Income'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove, color: Colors.red),
              title: const Text('Add Expense'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off_csred, color: Colors.orange),
              title: const Text('Add Loan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddLoanScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          onTap: (value) => setState(() => index = value),
          fixedColor: const Color.fromARGB(221, 227, 170, 120),
          currentIndex: index,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          elevation: 3,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home' ,

            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
  colors: const [
    Color.fromARGB(255, 231, 129, 101),
    Color.fromARGB(255, 237, 185, 51),
    Color.fromARGB(255, 236, 199, 148),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
,

            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(CupertinoIcons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
