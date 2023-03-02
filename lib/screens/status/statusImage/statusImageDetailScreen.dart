// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/controller/active_app_controller.dart';
import 'package:status_saver/controller/fileController.dart';

class StatusImageDetailScreen extends StatefulWidget {
  int indexNo;

  StatusImageDetailScreen({Key? key, required this.indexNo}) : super(key: key);

  @override
  _StatusImageDetailScreenState createState() => _StatusImageDetailScreenState();
}

class _StatusImageDetailScreenState extends State<StatusImageDetailScreen> {
  Uri? myUri;
  FileController fileController = Get.put(FileController());
  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.indexNo;
    myUri = Uri.parse(fileController.allStatusImages.elementAt(widget.indexNo).filePath);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorsTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorsTheme.black,
        title: Text("Status Image"),
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles(
                  text: "Have a look on this Status",
                  [XFile(myUri!.path.replaceAll("%20"," "))],
                );
              },
              icon: Icon(Icons.share)),
          Obx(() => Visibility(
              visible: fileController.allStatusImages.elementAt(currentIndex).isSaved,
              child: IconButton(
                  onPressed: () {
                    // ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
                    ReusingWidgets.toast(text: "Image Already Saved");
                  },
                  icon: Icon(Icons.done,color: ColorsTheme.doneColor,)))),
          Obx(() => Visibility(
              visible: !(fileController.allStatusImages.elementAt(currentIndex).isSaved),
              child: IconButton(
                  onPressed: () {

                    _activeAppController.activeApp.value == 1 ?
                    GallerySaver.saveImage(myUri!.path.replaceAll("%20"," "),
                        albumName: "StatusSaver",
                        toDcim: true).then((value) {fileController.allStatusImages.elementAt(currentIndex).isSaved = true;fileController.allStatusImages.refresh();}) :
                    GallerySaver.saveImage(myUri!.path.replaceAll("%20"," "),
                        albumName: "StatusSaverBusiness",
                        toDcim: true).then((value) {fileController.allStatusImages.elementAt(currentIndex).isSaved = true;fileController.allStatusImages.refresh();});
                    // ReusingWidgets.snackBar(context: context, text: "Image Saved");
                    ReusingWidgets.toast(text: "Image Saved");


                  },
                  icon: Icon(Icons.save_alt)))),
        ],
      ),
      body: Obx(()=> Container(
        color: ColorsTheme.black,
        height: h,
        child: CarouselSlider(
             items: fileController.allStatusImages.map((index) {
            return Builder(
            builder: (BuildContext context) {
                return InteractiveViewer(
                  panAxis: PanAxis.free,
                  panEnabled: false,
                  minScale: 0.5,
                  maxScale: 5,
                  child: Hero(
                    tag: currentIndex,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(fileController.allStatusImages.elementAt(currentIndex).filePath),
                          fit: BoxFit.fill,
                          // width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          }).toList(),
            options: CarouselOptions(
              aspectRatio: 0.75,
              viewportFraction: 1,
              animateToClosest: true,
              initialPage: currentIndex,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  log('index $index');
                  currentIndex = index;
                  myUri = Uri.parse(fileController.allStatusImages.elementAt(currentIndex).filePath);
                });
              },
              scrollDirection: Axis.horizontal,
            )
        ),
      ),),
    );
  }
}