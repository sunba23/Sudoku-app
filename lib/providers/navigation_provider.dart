import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  // int _currentIndex = 0;
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    print("setting currentIndex to $index");
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToSettingsPage() {
    print("navigateToSettingsPage");
    _currentIndex = 3;
    notifyListeners();
  }

  void navigateToAppearancePage() {
    print("navigateToAppearancePage");
    _currentIndex = 4;
    notifyListeners();
  }
}