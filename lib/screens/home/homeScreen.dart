// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, null_check_always_fails

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/screens/setting/settingScreen.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../../bottomNavbar/bottomNavbarScreen.dart';
import '../../../generated/assets.dart';
import '../../controller/fileController.dart';
import '../../model/fileModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory whatsAppDirectory ;
 // late Directory businessWhatsAppDirectory;
  late Directory savedDirectory;
  final FileController fileController = Get.put(FileController());


  @override
  void initState() {
    super.initState();
  }

  getSelectedDetails(){
    imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
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
    return WillPopScope(
      onWillPop: (){
        ReusingWidgets.exitDialogueBox(
            context: context,
            onPress: (){
              Future.delayed(Duration(milliseconds: 1),() {
                exit(0);
              });
            },
        );
        return null!;
      },
      child: Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Saver\n',
                    style: ThemeTexts.textStyleTitle1.copyWith(
                      color: ColorsTheme.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),

                  ///WhatsApp
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesWhatsappIcon,
                      title: "WhatsApp Status",
                      subTitle: "Download Photo and Video Status",
                    color: Colors.greenAccent,
                    context: context,
                    onTap: ()async{
                       whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
                       savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                       await getSelectedDetails();
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                    }
                  ),

                  ///WhatsApp Business
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesWhatsappBusinessIcon,
                      title: "WhatsApp Business Status",
                      subTitle: "Download Photo and Video Status",
                       color: Colors.green,
                    context: context,
                      onTap: ()async{
                        whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
                        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                        await getSelectedDetails();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));


                      }
                  ),

                  ///Stickers
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesStickerIcon,
                      title: "WhatsApp Stickers",
                      subTitle: "Add Stickers to your WhatsApp",
                       color: Colors.yellow,
                    context: context,
                      onTap: (){
                        ReusingWidgets.toast(text: "Not Available");
                      }
                  ),

                  ///Settings
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesSettingsIcon,
                      title: "Settings",
                      subTitle: "Settings of StatusSaver",
                       color: Colors.orange,
                    context: context,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsScreen()));
                      }
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}