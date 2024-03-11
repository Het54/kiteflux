import 'package:flutter/material.dart';
import 'package:kiteflux/etoken_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiteflux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Etoken(),
    );
  }
}
