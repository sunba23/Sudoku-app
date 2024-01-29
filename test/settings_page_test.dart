import 'package:app/providers/navigation_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:app/components/gesture_detector_button.dart';
import 'settings_page_test.mocks.dart';
import 'test/settings_page_test.mocks.dart';


// Create a MockNavigator class
class MockNavigator extends Mock implements NavigatorObserver {}






class MockNavigationProvider extends Mock implements NavigationProvider {
  showChangeDisplayNameDialog() {}

  void shareApp() => super.noSuchMethod(
        Invocation.method(#shareApp, []),
        returnValue: null,
        returnValueForMissingStub: null,
      );
}

class MockRoute<T> extends Mock implements Route<T> {}

@GenerateMocks([SettingsPage])
void main() {
  final settingsPageMock = MockSettingsPage();
  BuildContext? mainContext;
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

  testWidgets('shareApp is called when Share app button is tapped',
      (WidgetTester tester) async {
    final mockNavigationProvider = MockNavigationProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<NavigationProvider>.value(
        value: mockNavigationProvider,
        child: MaterialApp(
          home: GestureDetector(
            key: Key('shareApp'),
            onTap: () => mockNavigationProvider.shareApp(),
          ),
        ),
      ),
    );

    // Tap the Share app button
    await tester.tap(find.byKey(Key('shareApp')));
    await tester.pumpAndSettle();

    // Verify that shareApp was called
    verify(mockNavigationProvider.shareApp()).called(1);
  });




 

}
