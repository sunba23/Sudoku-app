import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:app/utils/rive_utils.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:rive/rive.dart';

import '../components/animated_bar.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'camera_page.dart';
import 'package:flutter/material.dart';
import 'package:app/models/rive_asset.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RiveAsset selectedBottomNav = bottomNavs[1];
  int currentIndex = 1;
  final SwiperController _swiperController = SwiperController();

  List pages = [
    const HistoryPage(),
    CameraPage(),
    const ProfilePage(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      selectedBottomNav = bottomNavs[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Swiper(
        controller: _swiperController,
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
        // loop: false, // find a way to use it without the ugly icons
        itemCount: pages.length,
        onIndexChanged: (int index) {
          bottomNavs[index].input!.change(true);
          onTap(index);
          Future.delayed(const Duration(seconds: 1), () {
            bottomNavs[index].input!.change(false);
          });
        },
        pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.transparent,
            activeColor: Colors.transparent,
          )
        ),
        control: const SwiperControl(
          color: Colors.transparent, //this is scuffed xd, how to pass null?
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 57, 64, 83),
              borderRadius: BorderRadius.all(Radius.circular(40)),
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
                        if (bottomNavs[index] != selectedBottomNav) {
                          setState(() {
                            selectedBottomNav = bottomNavs[index];
                            onTap(index);
                          });
                          _swiperController.move(index);
                        }
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
                              opacity:
                              bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
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
                                  debugPrint(controller.toString());

                                  if (index != 1) {
                                    bottomNavs[index].input =
                                    controller.findSMI("active") as SMIBool;
                                  } else {
                                    bottomNavs[index].input =
                                    controller.findSMI("isActive") as SMIBool;
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
    );
  }
}