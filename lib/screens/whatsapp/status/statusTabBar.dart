// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/screens/whatsapp/status/statusImage/statusImageScreen.dart';
import 'package:status_saver/screens/whatsapp/status/statusVideo/statusVideoScreen.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../home/homeScreen.dart';

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
        appBar: AppBar(
          title: Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.textColor,letterSpacing: 1),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: ColorsTheme.textColor,
            onPressed: (){
              Get.offAll(HomeScreen());
            },
          ),
          backgroundColor: ColorsTheme.backgroundColor,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: ColorsTheme.textColor,
            indicatorColor: ColorsTheme.textColor,
            indicatorWeight: 5,
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