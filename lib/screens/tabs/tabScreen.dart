// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// import 'dart:developer';
// import 'dart:io';
// import 'package:device_apps/device_apps.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
// import 'package:status_saver/controller/active_app_controller.dart';
// import 'package:status_saver/generated/assets.dart';
// import 'package:status_saver/screens/status/statusImage/statusImageScreen.dart';
// import 'package:status_saver/screens/status/statusVideo/statusVideoScreen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../app_theme/color.dart';
// import '../../../app_theme/text_styles.dart';
// import '../../../bottomNavbar/bottomNavbarScreen.dart';
// import '../../../controller/fileController.dart';
// import '../../../model/fileModel.dart';
//
// class TabScreen extends StatefulWidget {
//    TabScreen({Key? key,required this.titleText,required this.tabLabel1,required this.tabLabel2,required this.tabClass1,required this.tabClass2,}) : super(key: key);
//
//    String titleText;
//    String tabLabel1;
//    String tabLabel2;
//    var tabClass1;
//    var tabClass2;
//
//
//   @override
//   State<TabScreen> createState() => _TabScreenState();
// }
//
// class _TabScreenState extends State<TabScreen> {
//   int? androidSDK;
//   FileController fileController = Get.put(FileController());
//
//   late List<String> imageList;
//   late List<String> videoList;
//   late List<String> savedList;
//
//   late Directory directoryPath;
//   late Directory savedDirectory;
//
//   late SharedPreferences _prefs;
//
//   final ActiveAppController _activeAppController = Get.put(ActiveAppController());
//
//   @override
//   void initState() {
//     super.initState();
//     getPrefs();
//   }
//
//   getPrefs() async {
//     _prefs =  await SharedPreferences.getInstance();
//   }
//
//   checkAndroidVersion(int newValue) async {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     setState(() {
//       androidSDK = androidInfo.version.sdkInt;
//     });
//     if (androidSDK! >= 30) {
//       if (newValue == 1) {
//         try {
//           directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
//           try{
//             if(await directoryPath.exists()){
//               savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//               _prefs.setInt("statusValue", 1);
//               _activeAppController.changeActiveApp(1);
//               getSelectedDetails();
//             }
//             else{
//               ReusingWidgets.toast(text: "No WhatsApp Found");
//             }
//           }
//           catch(e){
//             print(e);
//           }
//         }
//         catch (e) {
//           ReusingWidgets.toast(text: "No WhatsApp Found");
//           // pre.setInt("statusValue", 2);
//         }
//       } else if (newValue == 2) {
//         try {
//           directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
//           try{
//             if(await directoryPath.exists()){
//               savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
//               _prefs.setInt("statusValue", 2);
//               _activeAppController.changeActiveApp(2);
//               getSelectedDetails();
//             }
//             else{
//               ReusingWidgets.toast(text: "No Business WhatsApp Found");
//             }
//           }
//           catch(e){
//             print(e);
//           }
//         }
//         catch (e) {
//           ReusingWidgets.toast(text: "No Business WhatsApp Found");
//           _prefs.setInt("statusValue", 1);
//         }
//       } else if (newValue == 3) {
//         try {
//           _prefs.setInt("statusValue", 3);
//           directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.gb/GB WhatsApp/Media/.Statuses');
//           savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//
//           _activeAppController.changeActiveApp(3);
//           getSelectedDetails();
//         }
//         catch (e) {
//           print("Error is $e");
//         }
//       } else {
//       }
//     }
//     else if (androidSDK! < 30) {
//       // if (newValue == 1) {
//       //   try {
//       //
//       //     directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
//       //     savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//       //
//       //     _activeAppController.changeActiveApp(1);
//       //     getSelectedDetails();
//       //   }
//       //   catch (e) {
//       //     print("Error is $e");
//       //     ReusingWidgets.toast(text: "No WhatsApp Found");
//       //     _prefs.setInt("statusValue", 2);
//       //   }
//       //
//       //
//       // }
//
//       if (newValue == 1) {
//         try {
//           directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
//           try{
//             if(await directoryPath.exists()){
//               savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//               _prefs.setInt("statusValue", 1);
//               _activeAppController.changeActiveApp(1);
//               getSelectedDetails();
//             }
//             else{
//               ReusingWidgets.toast(text: "No WhatsApp Found");
//             }
//           }
//           catch(e){
//             print(e);
//           }
//         }
//         catch (e) {
//           ReusingWidgets.toast(text: "No WhatsApp Found");
//           // pre.setInt("statusValue", 2);
//         }
//       }
//       else if (newValue == 2) {
//         // try {
//         //   _prefs.setInt("statusValue", 2);
//         //   directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
//         //   savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
//         //
//         //   _activeAppController.changeActiveApp(2);
//         //   getSelectedDetails();
//         // }
//         // catch (e) {
//         //   print("Error is $e");
//         //   ReusingWidgets.toast(text: "No Business WhatsApp Found");
//         //   _prefs.setInt("statusValue", 1);
//         // }
//
//         try {
//           directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
//           try{
//             if(await directoryPath.exists()){
//               savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
//               _prefs.setInt("statusValue", 2);
//               _activeAppController.changeActiveApp(2);
//               getSelectedDetails();
//             }
//             else{
//               ReusingWidgets.toast(text: "No Business WhatsApp Found");
//             }
//           }
//           catch(e){
//             print(e);
//           }
//         }
//         catch (e) {
//           ReusingWidgets.toast(text: "No Business WhatsApp Found");
//           _prefs.setInt("statusValue", 1);
//         }
//
//       }
//       else if (newValue == 3) {
//         try {
//           _prefs.setInt("statusValue", 3);
//           directoryPath = Directory('/storage/emulated/0/GB WhatsApp/Media/.Statuses');
//           savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//
//           _activeAppController.changeActiveApp(3);
//           getSelectedDetails();
//         }
//         catch (e) {
//           print("Error is $e");
//           ReusingWidgets.toast(text: "No GB WhatsApp Found");
//         }
//       } else {
//       }
//     }
//     else {
//     }
//   }
//
//   getSelectedDetails() {
//     imageList =directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
//     videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
//     savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
//     getImageData();
//     getVideoData();
//   }
//
//   getImageData() {
//     fileController.allStatusImages.value = [];
//     if (imageList.isNotEmpty) {
//       for (var element in imageList) {
//         // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {
//         if (_activeAppController.activeApp.value == 1){
//           if (savedList.map((e) =>
//               e.split("StatusSaver/").last.split(".").first.toString()).
//           contains(element.split(".Statuses/").last.split(".").first)) {
//
//             fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
//           } else {
//             // print("ELSE${element.substring(72,104)}");
//
//             fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
//           }
//         }else if(_activeAppController.activeApp.value == 2){
//           if (savedList.map((e) =>
//               e.split("StatusSaverBusiness/").last.split(".").first.toString()).
//           contains(element.split(".Statuses/").last.split(".").first)) {
//             fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
//           } else {
//             // print("ELSE${element.substring(72,104)}");
//             fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
//           }
//         }
//
//       }
//     }
//   }
//
//   getVideoData() {
//     fileController.allStatusVideos.value = [];
//     if (videoList.isNotEmpty) {
//       for (var element in videoList) {
//         // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {
//
//
//         if (_activeAppController.activeApp.value == 1){
//           if (savedList.map((e) =>
//               e.split("StatusSaver/").last.split(".").first.toString()).
//           contains(element.split(".Statuses/").last.split(".").first)) {
//             fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
//           } else {
//             fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
//           }
//         }
//         else if(_activeAppController.activeApp.value == 2){
//           if (savedList.map((e) =>
//               e.split("StatusSaverBusiness/").last.split(".").first.toString()).
//           contains(element.split(".Statuses/").last.split(".").first)) {
//             fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
//           }
//           else {
//             fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 2,
//       child: Scaffold(
//         backgroundColor: ColorsTheme.primaryColor,
//         appBar: AppBar(
//           title: Text(
//             widget.titleText,
//             style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white, letterSpacing: 1),
//           ),
//           automaticallyImplyLeading: false,
//           leading: InkWell(
//               onTap: () {
//                 if (scaffoldKey.currentState!.isDrawerOpen) {
//                   scaffoldKey.currentState!.closeDrawer();
//                 } else {
//                   scaffoldKey.currentState!.openDrawer();
//                 }
//               },
//               child: Icon(Icons.menu)),
//           actions: [
//             Obx(() {
//               return Visibility(
//                 visible: _activeAppController.activeApp.value == 1,
//                 child: Tooltip(
//                   message: "Open WhatsApp",
//                   child: GestureDetector(
//                       onTap: () async {
//                         try {
//                           bool isInstalled =
//                           await DeviceApps.isAppInstalled('com.whatsapp');
//                           if (isInstalled) {
//                             DeviceApps.openApp("com.whatsapp").then((value) {
//                               ReusingWidgets.toast(text: "Opening WhatsApp...");
//                             });
//                           } else {
//                             launchUrl(Uri.parse("market://details?id=com.whatsapp"));
//                           }
//                         } catch (e) {
//                           ReusingWidgets.toast(text: e.toString());
//                         }
//                       },
//                       child: Image.asset(
//                         Assets.imagesWhatsappIcon,
//                         height: 25,
//                         width: 25,
//                       )),
//                 ),
//               );
//             }),
//             Obx(() {
//               return Visibility(
//                 visible: _activeAppController.activeApp.value == 2,
//                 child: Tooltip(
//                   message: "Open Business WhatsApp",
//                   child: GestureDetector(
//                       onTap: () async {
//                         try {
//                           bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
//                           if (isInstalled) {
//                             DeviceApps.openApp("com.whatsapp.w4b").then((value) {
//                               ReusingWidgets.toast(text: "Opening Business WhatsApp...");
//                             });
//                           } else {
//                             launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
//                           }
//                         } catch (e) {
//                           ReusingWidgets.toast(text: e.toString());
//                         }
//                       },
//                       child: Image.asset(
//                         Assets.imagesWhatsappBusinessIcon,
//                         height: 25,
//                         width: 25,
//                       )),
//                 ),
//               );
//             }),
//             // SizedBox(width: 10),
//             PopupMenuButton(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: ColorsTheme.white,
//               ),
//               itemBuilder: (context) =>
//               [
//                 PopupMenuItem(
//                   value: 1,
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         Assets.imagesWhatsappIcon,
//                         width: 25,
//                         height: 25,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text("WhatsApp"),
//                       Spacer(),
//                       Image.asset(
//                         _activeAppController.activeApp.value == 1 ? Assets
//                             .imagesCheck : Assets.imagesUnCheck,
//                         width: 20,
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 2,
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         Assets.imagesWhatsappBusinessIcon,
//                         width: 25,
//                         height: 25,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text("Business WhatsApp"),
//                       Spacer(),
//                       Image.asset(
//                         _activeAppController.activeApp.value == 2 ? Assets
//                             .imagesCheck : Assets.imagesUnCheck,
//                         width: 20,
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 3,
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         Assets.imagesGbWhatsappIcon,
//                         width: 25,
//                         height: 25,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text("GB WhatsApp"),
//                       Spacer(),
//                       Obx(() {
//                         return Image.asset(
//                           _activeAppController.activeApp.value == 3 ? Assets
//                               .imagesCheck : Assets.imagesUnCheck,
//                           width: 20,
//                           height: 20,
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ],
//               offset: Offset(0, 50),
//               elevation: 2,
//               onSelected: (value) async {
//
//                 if (value == 1) {
//                   try {
//                     try {
//                       bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
//                       if (isInstalled) {
//                         await checkAndroidVersion(1);
//                       }
//                       else {
//                         ReusingWidgets.toast(text: "No WhatsApp Found");
//                       }
//                     } catch (e) {
//                       ReusingWidgets.toast(text: e.toString());
//                     }
//
//                   } catch (e) {
//                     ReusingWidgets.toast(text: "No WhatsApp Found");
//                   }
//                 }
//                 else if (value == 2) {
//                   try {
//
//                     try {
//                       bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
//                       if (isInstalled) {
//                         await checkAndroidVersion(2);
//                       } else {
//                         ReusingWidgets.toast(text: "No WhatsApp Business Found");
//                       }
//                     } catch (e) {
//                       ReusingWidgets.toast(text: e.toString());
//                     }
//
//
//                   }
//                   catch (e) {
//                     ReusingWidgets.toast(text: "No WhatsApp Business Found");
//                   }
//                 }
//                 else if (value == 3) {
//                   ReusingWidgets.toast(text: "Not Available");
//                 }
//
//                 fileController.allStatusImages.forEach((element) {
//                   log("ELEMENT IS ${element.isSaved}");
//                 });
//               },
//             )
//           ],
//           backgroundColor: ColorsTheme.primaryColor,
//           elevation: 0,
//           bottom: TabBar(
//             unselectedLabelColor: ColorsTheme.lightWhite,
//             labelColor: ColorsTheme.white,
//             indicatorColor: ColorsTheme.lightWhite,
//             labelPadding: EdgeInsets.symmetric(horizontal: 2),
//             indicatorWeight: 3,
//             tabs: [
//               Tab(text: widget.tabLabel1),
//               Tab(text: widget.tabLabel2),
//               // Tab(text: "SAVED"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             widget.tabClass1,
//             widget.tabClass2,
//             // SavedScreen()
//           ],
//         ),
//       ),
//     );
//   }
// }
//
