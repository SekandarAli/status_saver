// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
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

   final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? statusValue = prefs.getInt('statusValue');
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
    // return MediaGrid();
  }
}



///
//
// ignore_for_file: prefer_const_constructors
//
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:saf/saf.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
//
// import 'app_theme/color.dart';
// import 'screens/status/statusImage/statusImageDetailScreen.dart';
//
//
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
//     getSync();
//
//     super.initState();
//   }
//
//
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
//   getSync() async{
//     var isSync = await saf.sync();
//     if (isSync as bool) {
//       var _paths = await saf.getCachedFilesPath();
//       loadImage(_paths);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Saf example app'),
//         ),
//         body:  GridView.builder(
//           key: PageStorageKey(widget.key),
//           itemCount: _paths.length,
//           physics: BouncingScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 5,
//               crossAxisSpacing: 5,
//               childAspectRatio: 0.75
//           ),
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>StatusImageDetailScreen(indexNo: index)));
//
//                 // Get.to(() => StatusImageDetailScreen(indexNo: index));
//               },
//               child:
//               ReusingWidgets.getSavedData(
//                 tag: _paths[index],
//                 context: context,
//                 file: File(_paths[index]),
//                 showPlayIcon: true,
//                 bgColor: ColorsTheme.primaryColor ,
//                 icon:Icons.save_alt,
//                 color: ColorsTheme.doneColor,
//                 onDownloadDeletePress:
//                     () {
//
//                   GallerySaver.saveImage(
//                       Uri.parse(_paths[index]).path,
//                       albumName: "StatusSaver",
//                       toDcim: true);
//                   ReusingWidgets.toast(text: "Image Saved");
//                 },
//                 onSharePress: () {
//                   // Share.shareXFiles(
//                   // text: "Have a look on this Status",
//                   // [XFile(Uri.parse(
//                   //     fileController.allStatusImages.elementAt(index).filePath).path)
//                   // ],
//                   // );
//                   Share.shareFiles(
//                     [Uri.parse(_paths[index]).path.replaceAll("%20"," ")],
//                     text: 'Have a look on this Status',
//                   );
//                 },
//               ),
//             );
//           },
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
//
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.orange),
//               ),
//               onPressed: () async {
//                 // final result = await FilePicker.platform.pickFiles();
//
//                 final result = await FilePicker.platform.getDirectoryPath();
//
//                 if (result != null) {
//                   // User picked a file or directory
//                   final files = result;
//                   // final directory = result.path;
//
//                   print("filesssssssss$files");
//                   // Do something with the selected files or directory
//                 }
//
//               },
//               child: const Text("aaa"),
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
