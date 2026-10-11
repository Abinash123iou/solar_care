import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/dashboard/screens/dashboard_screen.dart';
import 'package:solar_care/main.dart';

void main() {
  testWidgets('SolarCare Dashboard smoke test', (WidgetTester tester) async {
    // Build SolarCareApp and trigger a frame.
    await tester.pumpWidget(const SolarCareApp(home: DashboardScreen()));

    // Settle asynchronous data loading and animations
    await tester.pumpAndSettle();

    // Verify app title and user name are rendered
    expect(find.text('SolarCare'), findsWidgets);
    expect(find.text('Ravi Kumar'), findsOneWidget);

    // Verify key dashboard UI elements
    expect(find.text('Diagnose a Problem'), findsOneWidget);
    expect(find.text("Today's Generation"), findsOneWidget);
  });
}
