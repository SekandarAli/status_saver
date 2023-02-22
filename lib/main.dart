// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/model/fileModel.dart';
import 'package:status_saver/screens/home/homeScreen.dart';
import 'package:status_saver/screens/whatsapp/status/statusTabBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late List<String> imageList;
  // late List<String> videoList;
  // late List<String> savedList;

  // Directory whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
  // Directory businessWhatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
  // Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
  final FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    // imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    // videoList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    // savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
    // getImageData();
    // getVideoData();
    // getSavedData();
  }
  //
  // getImageData() {
  //   fileController.allStatusImages.value = [];
  //   if (imageList.isNotEmpty) {
  //     for (var element in imageList) {
  //       if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
  //         fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
  //       } else {
  //         // print("ELSE${element.substring(72,104)}");
  //         fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
  //       }
  //     }
  //   }
  // }
  //
  // getVideoData() {
  //   fileController.allStatusVideos.value = [];
  //   if (videoList.isNotEmpty) {
  //     for (var element in videoList) {
  //       if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
  //         fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
  //       } else {
  //         fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
  //       }
  //     }
  //   }
  // }
  //
  // getSavedData(){
  //   fileController.allStatusSaved.value = [];
  //   if(savedList.isNotEmpty){
  //     for (var element in savedList) {
  //       if(savedList.contains(element)){
  //         fileController.allStatusSaved.add(FileModel(filePath: element, isSaved: true));
  //       }
  //       else{
  //         fileController.allStatusSaved.add(FileModel(filePath: element, isSaved: false));
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return StatusTabScreen();
    return HomeScreen();
    // return MyHomePage();
  }
}

/*//
//
//
//
//
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<String> imagePaths = [
//     'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
//     'https://images.unsplash.com/photo-1580777187326-d45ec82084d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
//     'https://images.unsplash.com/photo-1531804226530-70f8004aa44e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
//     'https://images.unsplash.com/photo-1465056836041-7f43ac27dcb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
//     'https://images.unsplash.com/photo-1573553256520-d7c529344d67?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
//   ];
//
//   HashSet selectItems = HashSet();
//   bool isMultiSelectionEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: isMultiSelectionEnabled
//               ? IconButton(
//               onPressed: () {
//                 setState(() {
//                   isMultiSelectionEnabled = false;
//                   selectItems.clear();
//                 });
//               },
//               icon: Icon(Icons.close))
//               : null,
//           title: Text(isMultiSelectionEnabled ? getSelectedItemCount() : "Select/Unselect All"),
//           actions: [
//             Visibility(
//                 visible: isMultiSelectionEnabled,
//                 child: IconButton(
//                   onPressed: () {
//                     setState(() {
//                       if (selectItems.length == imagePaths.length) {
//                         selectItems.clear();
//                       } else {
//                         for (int index = 0; index < imagePaths.length; index++) {
//                           selectItems.add(imagePaths[index]);
//                         }
//                       }
//                     });
//                   },
//                   icon: Icon(
//                     Icons.select_all,
//                     color: (selectItems.length == imagePaths.length)
//                         ? Colors.black
//                         : Colors.white,
//                   ),
//                 ))
//           ],
//         ),
//         body: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 2,
//           childAspectRatio: 1.5,
//           children: imagePaths.map((String path) {
//             return GridTile(
//               child: InkWell(
//                 onTap: () {
//                   print(path);
//                   doMultiSelection(path);
//                 },
//                 onLongPress: () {
//                   isMultiSelectionEnabled = true;
//                   doMultiSelection(path);
//                 },
//                 child: Stack(
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Expanded(
//                             child: Image.network(
//                               path,
//                               color: Colors.black.withOpacity(selectItems.contains(path) ? 1 : 0),
//                               colorBlendMode: BlendMode.color,
//                             )),
//                       ],
//                     ),
//                     Visibility(
//                         visible: selectItems.contains(path),
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ));
//   }
//
//   String getSelectedItemCount() {
//     return selectItems.isNotEmpty ? "${selectItems.length} item selected" : "No item selected";
//   }
//
//    doMultiSelection(String path) {
//     if (isMultiSelectionEnabled) {
//       setState(() {
//         if (selectItems.contains(path)) {
//           selectItems.remove(path);
//           print("hello");
//         } else {
//           selectItems.add(path);
//           print("add");
//         }
//       });
//     }
//     else {}
//   }
//
// }*/
