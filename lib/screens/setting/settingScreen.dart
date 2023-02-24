// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_theme/color.dart';
import '../../app_theme/reusing_widgets.dart';
import '../../app_theme/text_styles.dart';
import '../../generated/assets.dart';
import '../home/homeScreen.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//
//
//
//     return Scaffold(
//       backgroundColor: ColorsTheme.backgroundColor,
//       appBar: AppBar(
//         title: Text('Settings',style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white,letterSpacing: 1),),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         // leading: IconButton(
//         //   icon: Icon(Icons.arrow_back_ios),
//         //   color: ColorsTheme.white,
//         //   onPressed: (){
//         //     Get.back();
//         //   },
//         // ),
//         backgroundColor: ColorsTheme.primaryColor,
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           width: w ,
//           height: h,
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               ListTile(
//                 leading: iconStyle(icon: Icons.delete_forever_outlined),
//                 title: textStyle(text: "Clear Saved Folder"),
//                 onTap: () {
//                   // savedDirectory.deleteSync(recursive: true);
//                   // savedDirectory.delete(recursive: false);
//                   // savedDirectory.path.removeAllWhitespace;
//                 },
//               ),
//               ListTile(
//                 leading: iconStyle(icon: Icons.star_border),
//                 title: textStyle(text: "Rate Us"),
//                 onTap: () async{
//                   _openAppReview();
//                 },
//               ),
//               ListTile(
//                 leading: iconStyle(icon: Icons.share_outlined),
//                 title: textStyle(text: "Share"),
//                 onTap: () {
//                   share();
//                 },
//               ),
//               ListTile(
//                 leading: iconStyle(icon: Icons.privacy_tip_outlined),
//                 title: textStyle(text: "Privacy Policy"),
//                 onTap: () async{
//
//                 },
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget textStyle({
//     required String text,
//   }){
//     return Text(
//       text,
//       style: ThemeTexts.textStyleTitle4.copyWith(color: Colors.black,fontWeight: FontWeight.normal),
//     );
//   }
//   Icon iconStyle({
//     required IconData icon,
//   }){
//     return Icon(icon,color: ColorsTheme.primaryColor,);
//   }
//
// }


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

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

    return Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('\nSETTINGS\n',
                    style: ThemeTexts.textStyleTitle1.copyWith(
                      color: ColorsTheme.primaryColor.withOpacity(1),
                      letterSpacing: 3,
                    ),
                  ),

                  // ///Delete Saved Images
                  // ReusingWidgets.settingCards(
                  //     icon: Icon(Icons.delete_forever_outlined,color: Colors.redAccent,),
                  //     title: "Delete Saved Images",
                  //     color: Colors.redAccent,
                  //     context: context,
                  //     onTap: (){
                  //       if (Directory(savedImagesDirectory!.path).existsSync()) {
                  //         final imageList = savedImagesDirectory!.listSync().map((item) =>
                  //         item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
                  //
                  //         log(imageList.toString());
                  //
                  //         imageList.forEach((element) {
                  //           File(element).deleteSync(recursive: true);
                  //           print("watch");
                  //         });
                  //       }
                  //       else{
                  //         log("s");
                  //       }
                  //     }
                  // ),

                  ///Rate
                  ReusingWidgets.settingCards(
                      icon: Icon(Icons.star_border,color: Colors.greenAccent,),
                      title: "Rate Us",
                      color: Colors.greenAccent,
                      context: context,
                      onTap: (){
                        _openAppReview();
                      }
                  ),

                  ///Privacy Policy
                  ReusingWidgets.settingCards(
                      icon: Icon(Icons.privacy_tip_outlined,color: Colors.amberAccent,),
                      title: "Privacy Policy",
                      color: Colors.amberAccent,
                      context: context,
                      onTap: (){
                        ReusingWidgets.toast(text: "No Available");
                      }
                  ),

                  ///Share
                  ReusingWidgets.settingCards(
                      icon: Icon(Icons.share_outlined,color: Colors.deepPurpleAccent,),
                      title: "Share",
                      color: Colors.deepPurpleAccent,
                      context: context,
                      onTap: (){
                        share();
                      }
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
