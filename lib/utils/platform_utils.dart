import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


Widget platformShowImage(File? image) {
  if (kIsWeb) {
    return Image.network(image!.path); // Web specific
  } else if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return Image.file(image!); // Mobile specific
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.fuchsia) {
    return Image.file(image!); // Desktop specific
  } else {
    return const Text('Unsupported platform');
  }
}

