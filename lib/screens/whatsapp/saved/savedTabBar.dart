// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/screens/whatsapp/saved/savedImage/savedImageScreen.dart';
import 'package:status_saver/screens/whatsapp/saved/savedVideo/savedVideoScreen.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../home/homeScreen.dart';

class SavedTabScreen extends StatefulWidget {
  const SavedTabScreen({Key? key}) : super(key: key);

  @override
  State<SavedTabScreen> createState() => _SavedTabScreenState();
}

class _SavedTabScreenState extends State<SavedTabScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white,letterSpacing: 1),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: ColorsTheme.white,
            onPressed: (){
              Get.offAll(()=>HomeScreen());
            },
          ),
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SavedImageScreen(),
            SavedVideoScreen(),
          ],
        ),
      ),
    );
  }
}