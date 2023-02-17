// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';

import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../../bottomNavbar/bottomNavbarScreen.dart';
import '../../../generated/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsTheme.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status Saver\n',
                style: ThemeTexts.textStyleTitle1.copyWith(
                  color: ColorsTheme.textColor,
                  letterSpacing: 2,
                ),
              ),
              ReusingWidgets.homeScreenCards(
                  iconImage: Assets.imagesWhatsappIcon,
                  title: "WhatsApp Status",
                  subTitle: "Download Photo and Video Status",
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBarScreen()));
                }
              ),
              ReusingWidgets.homeScreenCards(
                  iconImage: Assets.imagesWhatsappBusinessIcon,
                  title: "WhatsApp Business Status",
                  subTitle: "Download Photo and Video Status",
                  onTap: (){}
              ),

              ReusingWidgets.homeScreenCards(
                  iconImage: Assets.imagesStickerIcon,
                  title: "WhatsApp Stickers",
                  subTitle: "Add Stickers to your WhatsApp",
                  onTap: (){}
              ),

              ReusingWidgets.homeScreenCards(
                  iconImage: Assets.imagesSettingsIcon,
                  title: "Settings",
                  subTitle: "Settings of StatusSaver",
                  onTap: (){}
              ),
            ],
          ),
        ),
      )
    );
  }
}