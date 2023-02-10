// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/screens/saved/savedScreen.dart';
import '../app_theme/color.dart';
import '../app_theme/text_styles.dart';
import 'videos/videoScreen.dart';
import 'images/imageScreen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white,letterSpacing: 2),),
          backgroundColor: ColorsTheme.primaryColor,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: ColorsTheme.white,
            labelColor: ColorsTheme.themeColor,
            indicatorColor: ColorsTheme.themeColor,
            indicatorWeight: 5,
            tabs: [
              Tab(text: "IMAGES"),
              Tab(text: "VIDEOS"),
              Tab(text: "SAVED"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ImageScreen(),
            VideoScreen(),
            SavedScreen()
          ],
        ),
      ),
    );
  }
}
