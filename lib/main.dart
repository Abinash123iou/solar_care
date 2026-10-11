import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/sign_in_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/welcome/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SolarCareApp());
}

/// Root widget of the SolarCare / SolarDiagnostics Rooftop Solar MVP.
class SolarCareApp extends StatelessWidget {
  final Widget? home;

  const SolarCareApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolarDiagnostics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home ?? const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
