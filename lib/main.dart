// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/bottomNavbar/bottomNavbarScreen.dart';
import 'package:status_saver/controller/active_app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Status Saver",
        color: ColorsTheme.primaryColor,
        home: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  @override
  void initState() {
    super.initState();
    getActiveApp();
  }

  getActiveApp() async{

   final SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? statusValue= _prefs.getInt('statusValue');
    if(statusValue != null){
      _activeAppController.changeActiveApp(statusValue);
    }
    else{
      _activeAppController.changeActiveApp(1);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavBarScreen();
  }
}


// import 'dart:io';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:saf/saf.dart';
//
// /// Edit the Directory Programmatically Here
// const directory = "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late Saf saf;
//   var _paths = [];
//   @override
//   void initState() {
//     Permission.storage.request();
//     saf = Saf(directory);
//     super.initState();
//   }
//
//   loadImage(paths, {String k = ""}) {
//     var tempPaths = [];
//     for (String path in paths) {
//       if (path.endsWith(".jpg")) {
//         tempPaths.add(path);
//       }
//     }
//     if (k.isNotEmpty) tempPaths.add(k);
//     _paths = tempPaths;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Saf example app'),
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 if (_paths.isNotEmpty)
//                   ..._paths.map(
//                         (path) => Card(
//                       child: Image.file(
//                         File(path),
//                       ),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor:
//                 MaterialStateProperty.all(Colors.deepPurpleAccent),
//               ),
//               onPressed: () async {
//                 Saf.releasePersistedPermissions();
//               },
//               child: const Text("Release*"),
//             ),
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor:
//                 MaterialStateProperty.all(Colors.blueGrey.shade700),
//               ),
//               onPressed: () async {
//                 var cachedFilesPath = await saf.cache();
//                 if (cachedFilesPath != null) {
//                   loadImage(cachedFilesPath);
//                 }
//               },
//               child: const Text("Cache"),
//             ),
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.green),
//               ),
//               onPressed: () async {
//                 var isSync = await saf.sync();
//                 if (isSync as bool) {
//                   var _paths = await saf.getCachedFilesPath();
//                   loadImage(_paths);
//                 }
//               },
//               child: const Text("Sync"),
//             ),
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.orange),
//               ),
//               onPressed: () async {
//                 var isClear = await saf.clearCache();
//                 if (isClear != null && isClear) {
//                   loadImage([]);
//                 }
//               },
//               child: const Text("Clear"),
//             ),
//           ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: FloatingActionButton(
//           elevation: 30.0,
//           backgroundColor: Colors.black,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Text(
//                 "GRANT",
//                 style: TextStyle(fontSize: 13, color: Colors.red),
//               ),
//               Text(
//                 "Permission",
//                 style: TextStyle(fontSize: 7.8, color: Colors.red),
//               )
//             ],
//           ),
//           onPressed: () async {
//             await saf.getDirectoryPermission(isDynamic: true);
//           },
//         ),
//       ),
//     );
//   }
// }
