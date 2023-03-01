// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import '../app_theme/color.dart';
import '../app_theme/reusing_widgets.dart';
import '../app_theme/text_styles.dart';
import '../generated/assets.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  InAppReview? inAppReview;
  Directory? savedImagesDirectory;

  void _openAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.openStoreListing(
        appStoreId: '...',
        microsoftStoreId: '...',
      ).then((value) {});
    }
  }

  Future<void> share() async {
    await Share.share(
        'Status Saver of whatsapp \nhttps://play.google.com/store/apps/details?id=com.example.status_saver',
        subject: 'Status Saver');
  }


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    inAppReview = InAppReview.instance;
    savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

    return SafeArea(
      child: SizedBox(
        width: w / 1.7,
        height: h,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  // Positioned(
                  //   child: Image.asset(
                  //       Assets.imagesDrawerbg,
                  //       fit: BoxFit.fill,
                  //       width: w / 1.7,
                  //       height: 160,
                  //       color: ColorsTheme.primaryColor.withOpacity(1)
                  //     // height: h * 0.4,
                  //   ),
                  // ),
                  Container(
                    width: w / 1.7,
                    height: 160,
                    decoration: BoxDecoration(
                        color: ColorsTheme.primaryColor.withOpacity(1)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(Assets.imagesGbWhatsappIcon,width:  w * 0.20,color: ColorsTheme.white,),
                        Text('Status Saver',style: ThemeTexts.textStyleTitle2.copyWith(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ],
              ),

              ///Rate Us
               ListTile(
                leading: iconStyle(icon: Icons.star),
                title: textStyle(text: "Rate Us"),
                onTap: () async{
                  _openAppReview();
                },
              ),

              ///Share
               ListTile(
                leading: iconStyle(icon: Icons.share),
                title: textStyle(text: "Share"),
                onTap: () {
                  share();
                },
              ),

              ///Privacy Policy
               ListTile(
                leading: iconStyle(icon: Icons.privacy_tip),
                title: textStyle(text: "Privacy Policy"),
                onTap: () async{
                  ReusingWidgets.toast(text: "Not Available");

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget textStyle({
    required String text,
  }){
    return Text(
      text,
      style: ThemeTexts.textStyleTitle3.copyWith(color: Colors.black,fontWeight: FontWeight.normal),
    );
  }
  Icon iconStyle({
    required IconData icon,
  }){
    return Icon(icon,color: ColorsTheme.primaryColor,);
  }

}
