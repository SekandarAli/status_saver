// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import '../generated/assets.dart';

class ReusingWidgets {
  WillPopScope permissionDialogue({
    required BuildContext context,
    required double width,
    required double height,
    required Function() onPress,
  }) =>
      WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.imagesPermission,
                    width: width, height: height / 3.5),
                SizedBox(height: 10),
                Text(
                  "WhatsApp Permission",
                  style: ThemeTexts.textStyleTitle2.copyWith(
                      color: ColorsTheme.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text("Allow access to .STATUSES Folder to get all Status.",
                    textAlign: TextAlign.center,
                    style: ThemeTexts.textStyleTitle3.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w400)),
                SizedBox(height: 20),
                Text("*Require on Android 11 or higher or later",
                    textAlign: TextAlign.center,
                    style: ThemeTexts.textStyleTitle3.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w200)),
                SizedBox(height: 10),
                allowPermissionButton(
                  context: context,
                  text: "Allow permission",
                  onPress: () {
                    onPress();
                  },
                )
              ],
            ),
          ),
        ),
      );

  static Widget allowPermissionButton({
    required Function() onPress,
    required BuildContext context,
    required var text,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: () {
          onPress();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsTheme.primaryColor,
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(text,
            style: ThemeTexts.textStyleTitle3
                .copyWith(color: Colors.white, fontWeight: FontWeight.w300)),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({
    required BuildContext context,
    required String text,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 800)));
  }

  static AwesomeDialog dialogueAnimated({
    required BuildContext context,
    required DialogType dialogType,
    required Color color,
    required String title,
    required String desc,
  }) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogBackgroundColor: color,
      dialogType: dialogType,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      autoDismiss: true,
      title: title,
      titleTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      desc: desc,
      descTextStyle: TextStyle(color: Colors.white),
      autoHide: Duration(milliseconds: 2000),
    )..show();
  }

  static circularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: ColorsTheme.primaryColor,
        strokeWidth: 2,
      ),
    );
  }

/*  static Widget bottomLayer({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required Function() onSharePress,
    required Function() onDownloadDeletePress,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: IconButton(
                onPressed: () {
                  onSharePress();
                },
                icon: Icon(
                  Icons.share,
                  color: ColorsTheme.themeColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 1),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: IconButton(
                onPressed: () {
                  onDownloadDeletePress();
                },
                icon: Icon(icon, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  static Widget getSavedData({
    required String tag,
    required BuildContext context,
    required File file,
    required bool showPlayIcon,
    required Function() onDownloadDeletePress,
    required IconData icon,
    required Color color,
    required Function() onSharePress,
  }) {
    return Stack(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.loose,
          children: [
            Hero(
              tag: tag,
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.height,
                color: ColorsTheme.backgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
            // ReusingWidgets.bottomLayer(
            //   context: context,
            //   icon: Icons.delete,
            //   color: Colors.red,
            //   onSharePress: (){
            //     Share.shareFiles([file.path], text: 'Have a look on this Status');
            //   },
            //   onDownloadDeletePress: (){
            //     onDownloadDeletePress();
            //   },
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.yellow,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              // height: 40,
              child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            onPressed: () {
                              onSharePress();
                            },
                            icon: Icon(
                              Icons.share,
                              color: ColorsTheme.themeColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 1),
                      Expanded(
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            onPressed: () {
                              onDownloadDeletePress();
                            },
                            icon: Icon(icon, color: color),
                          ),
                        ),
                      ),
                    ],
                  )),

          ],
        ),
        showPlayIcon == true
            ? Container()
            : Center(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5)),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: ColorsTheme.white,
                  ),
                ),
              ),
      ],
    );
  }

  static Widget homeScreenCards({
    required String iconImage,
    required String title,
    required String subTitle,
    required Function() onTap,
  }) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  iconImage,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: ThemeTexts.textStyleTitle3.copyWith(
                            color: ColorsTheme.textColor,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Text(subTitle,
                        style: ThemeTexts.textStyleTitle4.copyWith(
                            color: ColorsTheme.textColor,
                            fontWeight: FontWeight.normal)),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

// Share.shareFiles([Uri.parse(imageList[index]).path], text: 'Have a look on this Status');
