// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/screens/whatsapp/status/statusImage/statusImageScreen.dart';
import 'package:status_saver/screens/whatsapp/status/statusVideo/statusVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../../bottomNavbar/bottomNavbarScreen.dart';
import '../../../controller/fileController.dart';
import '../../../model/fileModel.dart';
import '../../home/homeScreen.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({Key? key}) : super(key: key);

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> {

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  int? androidSDK;
  FileController fileController = Get.put(FileController());

  late Directory directoryPath ;
  late Directory savedDirectory;

  bool showWhatsAppIcon = true;

  checkAndroidVersion() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      print("Version Greater than 30");
      try {
        print("Version Greater");
        directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
        getSelectedDetails();
      }
      catch (e) {
        print("Error is $e");
      }
    }
    else if (androidSDK! < 30) {
      print("Version Less than 30");
      try {
        print("Version Less");
        directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
        getSelectedDetails();
      }
      catch (e) {
        print("Error is $e");
      }
    }
    else{
      print("ERROR");
    }
  }

  getSelectedDetails(){
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
  }

  getImageData() {
    fileController.allStatusImages.value = [];
    if (imageList.isNotEmpty) {
      for (var element in imageList) {
        // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {
        if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
        } else {
          // print("ELSE${element.substring(72,104)}");
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  getVideoData() {
    fileController.allStatusVideos.value = [];
    if (videoList.isNotEmpty) {
      for (var element in videoList) {
        // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {
        if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
        } else {
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsTheme.primaryColor,
        appBar: AppBar(
          title: Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white,letterSpacing: 1),),
          automaticallyImplyLeading: false,
          // centerTitle: true,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios),
          //   color: ColorsTheme.white,
          //   onPressed: (){
          //     Get.offAll(()=>HomeScreen());
          //   },
          // ),
          leading: InkWell(
              onTap: (){
                if(scaffoldKey.currentState!.isDrawerOpen){
                  scaffoldKey.currentState!.closeDrawer();
                }
                else{
                  scaffoldKey.currentState!.openDrawer();
                }
              },
              child: Icon(Icons.menu)),
          actions: [


            Visibility(
              visible: showWhatsAppIcon,
              child: Tooltip(
                message: "Open Business WhatsApp",
                child: GestureDetector(
                    onTap: ()async {
                    //   try {
                    //   bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
                    //   if (isInstalled) {
                    //     DeviceApps.openApp("com.whatsapp.w4b").then((value){
                    //       ReusingWidgets.toast(text: "Opening Business WhatsApp...");
                    //     });
                    //   }
                    //   else {
                    //     launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
                    //   }
                    // } catch (e) {
                    //     ReusingWidgets.toast(text: e.toString());
                    //   }

                      try{
                        directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
                        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                        // await checkAndroidVersion();
                        await getSelectedDetails();
                        showWhatsAppIcon = false;
                        setState(() {});
                      }
                      catch(e){
                        // ReusingWidgets.toast(text: e.toString());
                        ReusingWidgets.toast(text: "No WhatsApp Business Found");
                        print(e);
                      }
                    },
                    child: Image.asset(Assets.imagesWhatsappBusinessIcon,height: 30,width: 30,)),
              ),
            ),

            // SizedBox(width: 10),

            Visibility(
              visible: !showWhatsAppIcon,
              child: Tooltip(
                message: "Open WhatsApp",
                child: GestureDetector(
                    onTap: ()async {
                      // try {
                      //   bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
                      //   if (isInstalled) {
                      //     DeviceApps.openApp("com.whatsapp").then((value){
                      //       ReusingWidgets.toast(text: "Opening WhatsApp...");
                      //     });
                      //   }
                      //   else {
                      //     launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                      //   }
                      // } catch (e) {
                      //   ReusingWidgets.toast(text: e.toString());
                      // }



                      try{
                        directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
                        // directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
                        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                        // await checkAndroidVersion();
                        await getSelectedDetails();
                        showWhatsAppIcon = true;
                        setState(() {});
                      }
                      catch(e){
                        // ReusingWidgets.toast(text: e.toString());
                        ReusingWidgets.toast(text: "No WhatsApp Found");
                        print(e);
                      }
                    },
                    child: Image.asset(Assets.imagesWhatsappIcon,height: 30,width: 30,)),
              ),
            ),
            SizedBox(width: 10),
          ],
          backgroundColor: ColorsTheme.primaryColor,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: ColorsTheme.lightWhite,
            labelColor: ColorsTheme.white,
            indicatorColor: ColorsTheme.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 2),
            indicatorWeight: 8,
            tabs: [
              Tab(text: "IMAGES"),
              Tab(text: "VIDEOS"),
              // Tab(text: "SAVED"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatusImageScreen(),
            StatusVideoScreen(),
            // SavedScreen()
          ],
        ),
      ),
    );
  }
}

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}