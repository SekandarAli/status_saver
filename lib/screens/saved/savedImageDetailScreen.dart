// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/controller/fileController.dart';

class SavedImageDetailScreen extends StatefulWidget {
  var imgPath;
  var imgList;

  SavedImageDetailScreen({Key? key, required this.imgPath,required this.imgList}) : super(key: key);

  @override
  _SavedImageDetailScreenState createState() => _SavedImageDetailScreenState();
}

class _SavedImageDetailScreenState extends State<SavedImageDetailScreen> {

  FileController fileController = Get.put(FileController());


  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Saved Image"),
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          // onPressed: () => Get.offAll(TabScreen()),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles(
                  text: "Have a look on this Status",
                  [XFile(widget.imgPath.path)],
                );
              },
              icon: Icon(Icons.share)),
        ],
      ),
      // body: Hero(
      //   tag: widget.imgList,
      //   child: Center(
      //     child: Image.file(
      //       widget.imgPath,
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
       body: CarouselSlider.builder(
         itemCount: fileController.allStatusImages.length,
         itemBuilder: (BuildContext context, int index,_) {
           // log(fileController.allStatusImages.elementAt(index).filePath);
           return InteractiveViewer(
             panEnabled: false,
             boundaryMargin: EdgeInsets.all(100),
             minScale: 0.5,
             maxScale: 2,
             child: Image.file(
               File(fileController.allStatusImages.elementAt(index).filePath),
               fit: BoxFit.contain,
               // width: double.infinity,
             ),
           );
         },
         options: CarouselOptions(
           animateToClosest: false,
           autoPlay: false,
           enlargeCenterPage: true,
           // enableInfiniteScroll: false,
           disableCenter: false,
           viewportFraction: 1.0,
           aspectRatio: 0.75,
           initialPage: 0,
         ),
       )
    );
  }
}
