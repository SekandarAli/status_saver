// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
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
  int currentIndex = 0;

  bool? isTapped;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.indexNo;
    myUri = Uri.parse(fileController.allStatusImages.elementAt(widget.indexNo).filePath);
  }

  @override
  Widget build(BuildContext context) {
    // savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
    // imageData = savedImagesFolder!.map((e) => e.substring(37, 69).toString()).contains(widget.imgPath.substring(72, 104));
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
                  [XFile(myUri!.path)],
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
                  icon: Icon(Icons.done)))),
          Obx(() => Visibility(
              visible: !(fileController.allStatusImages.elementAt(currentIndex).isSaved),
              child: IconButton(
                  onPressed: () {
                      GallerySaver.saveImage(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) {
                        fileController.allStatusImages.elementAt(currentIndex).isSaved = true;
                        fileController.allStatusImages.refresh();
                      });
                      ReusingWidgets.dialogueAnimated(
                        context: context,
                        dialogType: DialogType.success,
                        color: ColorsTheme.primaryColor,
                        title: "Image Saved",
                        desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
                      );
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
            animateToClosest: true,
            autoPlay: false,
            enlargeCenterPage: false,
            // enlargeFactor: 0,
            enableInfiniteScroll: true,
            disableCenter: false,
            viewportFraction: 1.0,
            aspectRatio: 0.75,
            initialPage: currentIndex,
            padEnds: true,
              onPageChanged: (index, reason) {
              log('index $index');
              currentIndex = index;
              myUri = Uri.parse(fileController.allStatusImages.elementAt(currentIndex).filePath);
              setState(() {});
              },
            // onScrolled: (value){
            //   print("object");
            //   setState(() {});
            // }
          ),
        ),
      ),),
    );
  }
}
