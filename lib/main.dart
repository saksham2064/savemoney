import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saveyourmoney/firebase_options.dart';
import 'package:saveyourmoney/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");
  // await dotenv.load();

  // print('API KEY = ${dotenv.env['GEMINI_API_KEY']}');  // to verify loading

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ScreenUtilInit(designSize: const Size(360, 690), minTextAdapt: true, splitScreenMode: true, builder: (context, child) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
      ),
      home: const SplashScreen(),
    );
  }
}
