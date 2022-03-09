import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/utils/console.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
//  CameraController _controller;
  //Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Not cameras on emulator...
   /* if (getIt.get<AppGlobals>().cameras.isNotEmpty) {
      //_initCamera(getIt.get<AppGlobals>().cameras.first);
    }*/
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    //_controller.dispose();

    super.dispose();
  }

  // Init camera
  /*Future<void> _initCamera(CameraDescription description) async {
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      description,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    try {
      _initializeControllerFuture = _controller.initialize();
      // refresh screen
      setState(() {});
    } catch (e) {
      Console.log('ERROR', e, error: e);
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final CameraLensDirection lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = getIt
          .get<AppGlobals>()
          .cameras
          .firstWhere((CameraDescription description) => description.lensDirection == CameraLensDirection.back, orElse: () => null);
    } else {
      newDescription = getIt
          .get<AppGlobals>()
          .cameras
          .firstWhere((CameraDescription description) => description.lensDirection == CameraLensDirection.front, orElse: () => null);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      Console.log('ERROR', 'Camera not available');
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
