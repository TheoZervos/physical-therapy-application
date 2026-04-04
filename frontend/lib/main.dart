import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "package:frontend/viewmodels/viewmodels_lib.dart";
import 'package:frontend/views/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

late final List<CameraDescription> cameras;
late UserInfoViewModel userInfo;
late final ExerciseListViewModel allExercises;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  userInfo = UserInfoViewModel();
  allExercises = ExerciseListViewModel();
  userInfo.fetchUserInfo('assets/user_data');
  allExercises.fetchExercises('assets/all_exercises.json');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => userInfo),
        ChangeNotifierProvider(create: (context) => allExercises),
        Provider<List<CameraDescription>>.value(value: cameras)
      ],
      child: const IrisApp(),
    ),
  );
}

class IrisApp extends StatefulWidget {
  const IrisApp({super.key});

  @override
  State<IrisApp> createState() => _IrisAppState();
}

class _IrisAppState extends State<IrisApp> {
  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  void requestCameraPermission() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Iris: Physical Therapy Assistant",
      debugShowCheckedModeBanner: true,
      theme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}
