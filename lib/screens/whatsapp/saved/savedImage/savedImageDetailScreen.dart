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
  File imgPath;
  String imgListIndex;
  int indexNo;
  List imgList;

  SavedImageDetailScreen({Key? key, required this.imgList,required this.imgPath,required this.imgListIndex,required this.indexNo}) : super(key: key);

  @override
  _SavedImageDetailScreenState createState() => _SavedImageDetailScreenState();
}

class _SavedImageDetailScreenState extends State<SavedImageDetailScreen> {

  FileController fileController = Get.put(FileController());

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
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
          IconButton(
              onPressed: () {
                  widget.imgPath.delete();
                  fileController.allStatusImages.elementAt(widget.indexNo).isSaved = false;
                  fileController.allStatusImages.refresh();
                  fileController.allStatusSaved.refresh();
                  ReusingWidgets.snackBar(context: context, text: "Image Deleted Successfully");
                  Navigator.pop(context);
              }, icon: Icon(Icons.delete,color: ColorsTheme.dismissColor,)),
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
       body: Container(
         color: Colors.black,
         height: h ,
         child: CarouselSlider.builder(
           itemCount: widget.imgList.length,
           itemBuilder: (BuildContext context, int index,_) {
             return InteractiveViewer(
               panEnabled: false,
               boundaryMargin: EdgeInsets.all(100),
               minScale: 0.5,
               maxScale: 2,
               child: Hero(
                 tag: widget.imgListIndex,
                 child: Center(
                   child: Image.file(
                     File(widget.imgList[index]),
                     fit: BoxFit.contain,
                     // width: double.infinity,
                   ),
                 ),
               ),
             );
           },
           options: CarouselOptions(
             animateToClosest: false,
             autoPlay: false,
             enlargeCenterPage: true,
             enableInfiniteScroll: true,
             disableCenter: false,
             viewportFraction: 1.0,
             aspectRatio: 0.75,
             initialPage: widget.indexNo,
           ),
         ),
       )
    );
  }
}
