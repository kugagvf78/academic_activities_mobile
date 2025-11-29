import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/events/event_list.dart';
import 'screens/navigation.dart';

void main() {
  runApp(const AcademicApp());
}

class AcademicApp extends StatelessWidget {
  const AcademicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Activities',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: const Navigation(),

      routes: {'/cuocthi': (context) => const CuocThiScreen()},
    );
  }
}
