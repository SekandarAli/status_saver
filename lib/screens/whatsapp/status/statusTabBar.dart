// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/screens/whatsapp/status/statusImage/statusImageScreen.dart';
import 'package:status_saver/screens/whatsapp/status/statusVideo/statusVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../home/homeScreen.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({Key? key}) : super(key: key);

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsTheme.primaryColor,
        appBar: AppBar(
          title: Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white,letterSpacing: 1),),
          // centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: ColorsTheme.white,
            onPressed: (){
              Get.offAll(()=>HomeScreen());
            },
          ),
          actions: [
            Tooltip(
              message: "Open Business WhatsApp",
              child: GestureDetector(
                  onTap: ()async {
                    try {
                    bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
                    if (isInstalled) {
                      DeviceApps.openApp("com.whatsapp.w4b");
                      print("open");
                    } else {
                      print("not");
                      // launch("market://details?id=com.whatsapp");
                      launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
                    }
                  } catch (e) {e.toString();}

                  },
                  child: Image.asset(Assets.imagesWhatsappBusinessIcon,height: 30,width: 30,)),
            ),

            SizedBox(width: 10),

            Tooltip(
              message: "Open WhatsApp",
              child: GestureDetector(
                  onTap: ()async {
                    try {
                    bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
                    if (isInstalled) {
                      DeviceApps.openApp("com.whatsapp");
                      print("open");
                    } else {
                      print("not");
                      // launch("market://details?id=com.whatsapp");
                      launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                    }
                  } catch (e) {e.toString();}

                  },
                  child: Image.asset(Assets.imagesWhatsappIcon,height: 35,width: 35,)),
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