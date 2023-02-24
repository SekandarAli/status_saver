// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, null_check_always_fails, must_be_immutable

import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/screens/setting/settingScreen.dart';
import 'package:url_launcher/url_launcher.dart';
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
    createFolder();
  }

  createFolder() async {
    const folderName = "StatusSaver";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      // savedDirectory = Directory('/storage/emulated/0/DCIM/$folderName');
      print("Path Exist");
    }
    else {
      path.create();
    }
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
              child: Column(
                children: [
                  Text('\nSTATUS SAVER\n',
                    style: ThemeTexts.textStyleTitle1.copyWith(
                      color: ColorsTheme.primaryColor.withOpacity(1),
                      letterSpacing: 3,
                    ),
                  ),
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.count(
                        physics:
                        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 0),
                        crossAxisCount: 2,
                        children: [

                          ReusingWidgets.newHomeCard(
                              context: context,
                              title: "WhatsApp",
                              imageIcon: Assets.imagesWhatsappIcon,
                              onTap: ()async{
                                try{
                                  whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
                                  savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                                  await getSelectedDetails();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                                }
                                catch(e){
                                  ReusingWidgets.toast(text: e.toString());
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                                    text: "WhatsApp",
                                    packageName: "com.whatsapp",
                                    packageUrl: "market://details?id=com.whatsapp",
                                  )));
                                }
                              }
                          ),

                          ReusingWidgets.newHomeCard(
                              context: context,
                              title: "Business WhatsApp",
                              imageIcon: Assets.imagesWhatsappBusinessIcon,
                              onTap: ()async{
                                try{
                                  whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
                                  savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                                  await getSelectedDetails();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                                }
                                catch(e){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                                    text: "Business WhatsApp",
                                    packageName: "com.whatsapp.w4b",
                                    packageUrl: "market://details?id=com.whatsapp.w4b",
                                  )));
                                }
                              }
                          ),

                          ReusingWidgets.newHomeCard(
                              context: context,
                              title: "GB WhatsApp",
                              imageIcon: Assets.imagesGbWhatsappIcon,
                              onTap: ()async{
                                try{
                                  whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.gb/GB WhatsApp/Media/.Statuses');
                                  savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                                  await getSelectedDetails();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                                }
                                catch(e){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                                    text: "GB WhatsApp",
                                    packageName: "",
                                    packageUrl: "",
                                  )));
                                }
                              }
                          ),

                          ReusingWidgets.newHomeCard(
                              context: context,
                              title: "Stickers",
                              imageIcon: Assets.imagesStickerIcon,
                              onTap: (){
                                ReusingWidgets.toast(text: "Not Available");
                              }
                          ),

                          ReusingWidgets.newHomeCard(
                              context: context,
                              title: "Settings",
                              imageIcon: Assets.imagesSettingsIcon,
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingScreen()));
                              }
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              )

            /* Container(
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('\nSTATUS SAVER\n',
                    style: ThemeTexts.textStyleTitle1.copyWith(
                      color: ColorsTheme.primaryColor.withOpacity(1),
                      letterSpacing: 3,
                    ),
                  ),

                  ///WhatsApp





                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesWhatsappIcon,
                      title: "WhatsApp Status",
                      subTitle: "Download Photo and Video Status",
                    color: Colors.green.shade500,
                    context: context,
                    onTap: ()async{

                      try{
                        whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
                        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                        await getSelectedDetails();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                      }
                      catch(e){

                        ReusingWidgets.toast(text: e.toString());


                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                        //   text: "WhatsApp",
                        //   packageName: "com.whatsapp",
                        //   packageUrl: "market://details?id=com.whatsapp",
                        // )));
                      }
                    }
                  ),

                  ///WhatsApp Business
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesWhatsappBusinessIcon,
                      title: "WhatsApp Business Status",
                      subTitle: "Download Photo and Video Status",
                      color: Colors.green.shade700,
                    context: context,
                      onTap: ()async{
                        try{
                          whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
                          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                          await getSelectedDetails();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                        }
                        catch(e){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                            text: "Business WhatsApp",
                            packageName: "com.whatsapp.w4b",
                            packageUrl: "market://details?id=com.whatsapp.w4b",
                          )));
                        }
                      }
                  ),

                  ///GB WhatsApp
                  ReusingWidgets.homeScreenCards(
                      iconImage: Assets.imagesGbWhatsappIcon,
                      title: "GB WhatsApp Status",
                      subTitle: "Download Photo and Video Status",
                      color: Colors.black,
                      context: context,
                      onTap: ()async{
                        try{
                          whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.gb/GB WhatsApp/Media/.Statuses');
                          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
                          await getSelectedDetails();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                        }
                        catch(e){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NoWhatsAppFound(
                            text: "GB WhatsApp",
                            packageName: "",
                            packageUrl: "",
                          )));
                        }
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingScreen()));
                      }
                  ),
                ],
              ),
            ),
          )*/
          )
      ),
    );
  }
}



class NoWhatsAppFound extends StatelessWidget {
  NoWhatsAppFound({Key? key,required this.text,required this.packageName,required this.packageUrl,}) : super(key: key);

  String text;
  String packageName;
  String packageUrl;


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.imagesPermission,
                      width: w, height: h / 3.5),
                  SizedBox(height: 5),
                  Text("No $text Found, Please Install $text!",style: ThemeTexts.textStyleTitle3,textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  ReusingWidgets.allowPermissionButton(
                      onPress: () async{
                        try {
                          bool isInstalled = await DeviceApps.isAppInstalled(packageName);
                          if (isInstalled) {
                            DeviceApps.openApp(packageName);
                          } else {
                            launchUrl(Uri.parse(packageUrl));
                          }
                        } catch (e) {
                          ReusingWidgets.toast(text: e.toString());
                        }
                      },
                      context: context,
                      text: "Open $text"),

                  SizedBox(height: 10),

                  ReusingWidgets.allowPermissionButton(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      context: context,
                      text: "BACK"),
                ],
              ),
            ))
    );
  }
}
