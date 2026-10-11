import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/auth/screens/sign_in_screen.dart';
import 'package:solar_care/features/welcome/screens/welcome_screen.dart';
import 'package:solar_care/features/welcome/widgets/solar_leaf_logo.dart';
import 'package:solar_care/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SolarLeafLogo Tests', () {
    testWidgets('Renders leaf logo custom painter cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SolarLeafLogo(size: 60))),
        ),
      );
      expect(find.byType(SolarLeafLogo), findsOneWidget);
    });
  });

  group('WelcomeScreen Widget Tests', () {
    testWidgets('Renders branding, title, tagline, and both action buttons', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pumpAndSettle();

      // Brand Title & Tagline
      expect(find.text('SolarDiagnostics'), findsOneWidget);
      expect(find.text('Clean Energy. Better Tomorrow.'), findsOneWidget);

      // Logo
      expect(find.byType(SolarLeafLogo), findsOneWidget);

      // Buttons
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Tapping Sign In navigates to SignInScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('Tapping Create Account navigates to SignUp mode', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Register your rooftop solar system'), findsOneWidget);
    });

    testWidgets('Adapts to compact / small screen size without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('SolarDiagnostics'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SolarCareApp launches with WelcomeScreen by default', (
      tester,
    ) async {
      await tester.pumpWidget(const SolarCareApp());
      await tester.pumpAndSettle();

      expect(find.text('SolarDiagnostics'), findsOneWidget);
      expect(find.text('Clean Energy. Better Tomorrow.'), findsOneWidget);
    });
  });

  group('SignInScreen Widget Tests', () {
    testWidgets('Renders OAuth buttons, email, password, and toggles mode', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('you@example.com'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);

      // Toggle to Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Full Name'), findsOneWidget);
    });
  });
}
