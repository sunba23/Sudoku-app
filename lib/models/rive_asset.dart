import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
        required this.stateMachineName,
        required this.title,
        this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset("lib/assets/rive_assets/1298-2487-animated-icon-set-1-color.riv",
      artboard: "TIMER", stateMachineName: "TIMER_Interactivity", title: "Timer"),
  RiveAsset("lib/assets/rive_assets/4490-9149-little-icons.riv",
      artboard: "DASHBOARD",
      stateMachineName: "State Machine 1",
      title: "Dashboard"),
  RiveAsset("lib/assets/rive_assets/1298-2487-animated-icon-set-1-color.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "User"),
];