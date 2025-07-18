import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saveyourmoney/screens/home/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  col
      body: Container(
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
        ),
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.account_balance_wallet, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'MoneyNest',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
