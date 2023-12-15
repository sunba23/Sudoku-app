import 'package:app/pages/settings_page.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:app/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../components/animated_bar.dart';
import 'appearance_page.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'camera_page.dart';
import 'package:app/models/rive_asset.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RiveAsset selectedBottomNav = bottomNavs[1];
  int currentIndex = 1;

  late NavigationProvider navigationProvider;
  late PageController _pageController;

  List<Widget> pages = [
    const HistoryPage(),
    CameraPage(),
    const ProfilePage(),
    const SettingsPage(),
    const AppearancePage(),
  ];

  void onTap(int index) {
    if ((currentIndex == 3 || currentIndex == 4) && index == 2) {
      Provider.of<NavigationProvider>(context, listen: false).currentIndex = 2;
      _pageController.jumpToPage(index);
    } else {
      setState(() {
        currentIndex = index;
        if (index != 4 && index != 3){
          selectedBottomNav = bottomNavs[index];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.addListener(_onNavigationProviderChange);
  }

  @override
  void dispose() {
    navigationProvider.removeListener(_onNavigationProviderChange);
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationProviderChange() {
    _pageController.jumpToPage(navigationProvider.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        bottomNavs.length,
                            (index) => GestureDetector(
                          onTap: () {
                            bottomNavs[index].input!.change(true);
                            setState(() {
                              selectedBottomNav = bottomNavs[index];
                              onTap(index);
                            });
                            _pageController.jumpToPage(index);

                            Future.delayed(const Duration(seconds: 1), () {
                              bottomNavs[index].input!.change(false);
                            });

                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBar(
                                  isActive: bottomNavs[index] == selectedBottomNav),
                              SizedBox(
                                height: 36,
                                width: 36,
                                child: Opacity(
                                  opacity: bottomNavs[index] == selectedBottomNav
                                      ? 1
                                      : 0.5,
                                  child: RiveAnimation.asset(
                                    bottomNavs[index].src,
                                    artboard: bottomNavs[index].artboard,
                                    onInit: (artboard) {
                                      StateMachineController controller =
                                      RiveUtils.getRiveController(
                                        artboard,
                                        stateMachineName:
                                        bottomNavs[index].stateMachineName,
                                      );

                                      if (index != 1) {
                                        bottomNavs[index].input =
                                        controller.findSMI("active") as SMIBool;
                                      } else {
                                        bottomNavs[index].input = controller
                                            .findSMI("isActive") as SMIBool;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (int index) {
          if ([0, 1, 2].contains(index)) {
            bottomNavs[index].input!.change(true);
            onTap(index);
            Future.delayed(const Duration(seconds: 1), () {
              bottomNavs[index].input!.change(false);
            });
          } else {
            onTap(index);
          }
        },
      ),
    );
  }
}
