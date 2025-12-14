import 'package:academic_activities_mobile/services/api_service.dart';
import 'package:academic_activities_mobile/screens/auth/login_screen.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("access_token");

  // 🔥 VERY IMPORTANT: Inject token vào API Service
  if (token != null) {
    ApiService().setToken(token);
  }

  runApp(AcademicApp(initialRoute: token == null ? "/login" : "/navigation"));
}

class AcademicApp extends StatelessWidget {
  final String initialRoute;

  const AcademicApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Academic Activities',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        "/login": (context) => const LoginScreen(),
        "/navigation": (context) => const Navigation(),
      },
    );
  }
}
