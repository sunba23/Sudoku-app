import 'package:app/providers/navigation_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:app/pages/settings_page.dart';
import 'package:provider/provider.dart';

// Create a MockNavigator class
class MockNavigator extends Mock implements NavigatorObserver {}

class MockNavigationProvider extends Mock implements NavigationProvider {}

class MockRoute<T> extends Mock implements Route<T> {}

void main() {
  MockNavigator? mockNavigator;
  MockRoute? mockRoute;

  setUp(() {
    mockNavigator = MockNavigator();
    mockRoute = MockRoute();
  });

  testWidgets('goToProfile is called when back button is tapped',
      (WidgetTester tester) async {
    // Create a mock NavigationProvider
    final mockNavigationProvider = MockNavigationProvider();

    // Create the SettingsPage with the mock NavigationProvider
    await tester.pumpWidget(
      ChangeNotifierProvider<NavigationProvider>(
        create: (_) => mockNavigationProvider,
        child: MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Verify that currentIndex was set to 2
    verify(mockNavigationProvider.currentIndex = 2);
  });

  testWidgets(
    'showChangeDisplayNameDialog is called when Change display name button is tapped',
    (WidgetTester tester) async {
      // Create a mock NavigationProvider
      final mockNavigationProvider = MockNavigationProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => mockNavigationProvider,
          child: MaterialApp(
            home: SettingsPage(),
          ),
        ),
      );

      // Tap the Change display name button
      await tester.tap(find.byIcon(CupertinoIcons.pencil_outline));
      await tester.pumpAndSettle();

      // Verify that showChangeDisplayNameDialog was called
      // Add your verification code here
    },
  );

  testWidgets('shareApp is called when Share app button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(),
      ),
    );

    // Tap the Share app button
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();

    // Verify that shareApp was called
    // Add your verification code here
  });
}
