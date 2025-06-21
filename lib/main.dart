import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/Home.dart';
import 'Services/ProviderService.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (_) => MealState(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        primaryColor: const Color(0xFFF25700),
    colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFF25700),
    primary: const Color(0xFFF25700),
    ),),
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
    );
  }
}

