// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
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
                      color: ColorsTheme.primaryColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text("Allow access to .STATUSES Folder to get all Status.",
                    textAlign: TextAlign.center,
                    style: ThemeTexts.textStyleTitle3.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w400)),
                SizedBox(height: 20),
                // Text("*Require on Android 11 or higher or later",
                //     textAlign: TextAlign.center,
                //     style: ThemeTexts.textStyleTitle3.copyWith(
                //         color: Colors.black54, fontWeight: FontWeight.w200)),
                // SizedBox(height: 10),
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

  // static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({
  //   required BuildContext context,
  //   required String text,
  // }) {
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(text), duration: Duration(milliseconds: 800)));
  // }

  static Future<bool?> toast({
    required String text,
  }){
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorsTheme.primaryColor,
        textColor: Colors.white,
        fontSize: 16
    );
  }

  // static AwesomeDialog dialogueAnimated({
  //   required BuildContext context,
  //   required DialogType dialogType,
  //   required Color color,
  //   required String title,
  //   required String desc,
  // }) {
  //   return AwesomeDialog(
  //     context: context,
  //     animType: AnimType.scale,
  //     dialogBackgroundColor: color,
  //     dialogType: dialogType,
  //     dismissOnBackKeyPress: true,
  //     dismissOnTouchOutside: true,
  //     autoDismiss: true,
  //     title: title,
  //     titleTextStyle:
  //     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //     desc: desc,
  //     descTextStyle: TextStyle(color: Colors.white),
  //     autoHide: Duration(milliseconds: 2000),
  //   )
  //     ..show();
  // }

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
    required Color bgColor,
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: ColorsTheme.backgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.05,
                      height: 35,
                      color: ColorsTheme.primaryColor.withOpacity(0.6),
                      // color:  ColorsTheme.black,
                      child: IconButton(
                        onPressed: () {
                          onSharePress();
                        },
                        icon: Icon(
                          Icons.share,
                          // color: ColorsTheme.themeColor,
                          color: ColorsTheme.white,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.05,
                      height: 35,
                      color: ColorsTheme.black.withOpacity(0.6),
                      // color:  ColorsTheme.black,
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
            ),

          ],
        ),
        showPlayIcon == true ? Container() : Center(
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

/*  static Widget getSavedData({
    required String tag,
    required BuildContext context,
    required File file,
    required bool showPlayIcon,
    bool? dummyWidget,
    bool? isVisible,
    required Function() onDownloadDeletePress,
    required IconData icon,
    required Color color,
    required Color bgColor,
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
                    colorBlendMode: BlendMode.color,
                    color: Colors.black.withOpacity(isVisible == true ? 1 : 0),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      color: ColorsTheme.black.withOpacity(0.6),
                      // color:  ColorsTheme.black,
                      child: IconButton(
                        onPressed: () {
                          onSharePress();
                        },
                        icon: Icon(
                          Icons.share,
                          // color: ColorsTheme.themeColor,
                          color: ColorsTheme.white,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      color: ColorsTheme.primaryColor.withOpacity(0.6),
                      // color:  ColorsTheme.black,
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
            ),

          ],
        ),
        showPlayIcon == true ? Container() : Center(
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

        dummyWidget == false ? Container() :  Visibility(
            visible: isVisible!,
            child: const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ))
      ],
    );
  }*/


  static Widget homeScreenNewCard(){
    return  GridView.builder(
      itemCount: 5,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.75
      ),
      itemBuilder: (BuildContext context, int index) {


        return ;
      },
    );
  }

  static Widget homeScreenCards({
    required String iconImage,
    required String title,
    required String subTitle,
    required BuildContext context,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Card(
            elevation: 5,
            child: Row(
              children: [
                Container(
                  width: 15,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        iconImage,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ));
  }

  // static Widget newHomeCard({
  //   required BuildContext context,
  //   required String title,
  //   required String imageIcon,
  //   required Function() onTap,
  // }){
  //   return InkWell(
  //     onTap: (){
  //       onTap();
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
  //       decoration: BoxDecoration(
  //         color: ColorsTheme.white,
  //         borderRadius: BorderRadius.all(Radius.circular(20)),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 40,
  //             spreadRadius: 10,
  //           ),
  //         ],
  //       ),
  //       child: AnimationConfiguration.staggeredGrid(
  //         duration: Duration(milliseconds: 500),
  //         columnCount: 1,
  //         position: 1,
  //         child: ScaleAnimation(
  //           duration: Duration(milliseconds: 900),
  //           curve: Curves.fastLinearToSlowEaseIn,
  //           scale: 5,
  //           child: FadeInAnimation(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Image.asset(
  //                   imageIcon,
  //                   fit: BoxFit.cover,
  //                   width:  MediaQuery.of(context).size.width * 0.15,
  //                   height:  MediaQuery.of(context).size.width * 0.15,
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text(title,
  //                     style: ThemeTexts.textStyleTitle3.copyWith(
  //                         color: ColorsTheme.textColor,
  //                         fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static Future<String?> exitDialogueBox({
    required BuildContext context,
    required Function() onPress,

  }) =>
      showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.all(0),
              title: Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorsTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                  ),
                  child: Text("Exit", style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white),)),
              content: Container(
                  padding: EdgeInsets.all(15),
                  child: Text("Are you sure you want to Exit?",style: ThemeTexts.textStyleTitle3.copyWith(fontWeight: FontWeight.w500),)),
              actions: [

                TextButton(
                    onPressed: () {
                      onPress();
                    },
                    child: Text('OK',style: ThemeTexts.textStyleTitle3.copyWith(color: ColorsTheme.primaryColor))),

                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('CANCEL',style: ThemeTexts.textStyleTitle3.copyWith(color: ColorsTheme.primaryColor),)),
              ],
            );
          });


  static emptyData({required BuildContext context}){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ColorsTheme.backgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesEmpty,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              color: ColorsTheme.primaryColor,
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
            ),
            Text("Oops! No Data Found!",textAlign: TextAlign.center,style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.primaryColor),)
          ],
        ),
      ),
    );
  }

  static Widget elevatedButtons(){
    return  ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor:  MaterialStateProperty.all(Colors.black),
          foregroundColor:  MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // side: BorderSide(color: Colors.red)
              )
          )
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(Icons.save_alt),
            SizedBox(height: 5),
            Text("Save"),
          ],
        ),
      ),
    );
  }

  static Widget loadingAnimation(){
    return SpinKitCircle(color: ColorsTheme.primaryColor);
  }


  static Widget settingCards({
    required Icon icon,
    required String title,
    required BuildContext context,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Card(
            elevation: 5,
            child: Row(
              children: [
                Container(
                  width: 15,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     icon,
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: ThemeTexts.textStyleTitle2.copyWith(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w300)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> showDeleteDialog(BuildContext context, File file, {bool photo = true}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          title: Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ColorsTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
              child: Text("Delete File?", style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white),)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                    padding: EdgeInsets.all(15),
                    child: Text("Are you sure you want to delete this file?",style: ThemeTexts.textStyleTitle3.copyWith(fontWeight: FontWeight.w500),)),

              ],
            ),
          ),

          actions: [
            TextButton(
                onPressed: () {
                  file.deleteSync();
                  Navigator.pop(context);
                  ReusingWidgets.toast(text: 'File Deleted');
                },
                child: Text('DELETE',style: ThemeTexts.textStyleTitle3.copyWith(color: ColorsTheme.primaryColor))),

            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL',style: ThemeTexts.textStyleTitle3.copyWith(color: ColorsTheme.primaryColor),)),
          ],
        );
      },
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


// Share.shareFiles([Uri.parse(imageList[index]).path], text: 'Have a look on this Status');
