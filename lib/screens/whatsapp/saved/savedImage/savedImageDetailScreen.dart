// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/controller/fileController.dart';

class SavedImageDetailScreen extends StatefulWidget {
  // File imgPath;
  // String imgListIndex;
  int indexNo;
  List imgList;

  SavedImageDetailScreen({Key? key, required this.imgList,required this.indexNo}) : super(key: key);

  @override
  _SavedImageDetailScreenState createState() => _SavedImageDetailScreenState();
}

class _SavedImageDetailScreenState extends State<SavedImageDetailScreen> {

  FileController fileController = Get.put(FileController());
  Uri? myUri;

  @override
  void initState() {
    super.initState();
    myUri = Uri.parse(File(widget.imgList[widget.indexNo]).path);

  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                  [XFile(myUri!.path.replaceAll("%20"," "))],
                );
              },
              icon: Icon(Icons.share)),
          IconButton(
              onPressed: () {

                File(widget.imgList[widget.indexNo]).delete();
                for (var element in fileController.allStatusImages) {
                  if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                  contains( File(widget.imgList[widget.indexNo]).toString().split("StatusSaver/").last.split(".").first)){
                    element.isSaved = false;
                  }
                }
                  ReusingWidgets.toast(text: "Image Deleted Successfully");
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
         child: CarouselSlider(
           // itemCount: widget.imgList.length,
           // itemBuilder: (BuildContext context, int index,_) {
            items: widget.imgList.map((index) {
             return Builder(
               builder: (context) {
                 return InteractiveViewer(
                   panEnabled: false,
                   minScale: 0.5,
                   maxScale: 5,
                   child: Hero(
                     tag: widget.indexNo,
                     child: Padding(
                       padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(20),
                         child: Image.file(
                           File(widget.imgList[widget.indexNo]),
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
             enlargeFactor: 0,
             enableInfiniteScroll: true,
             disableCenter: false,
             viewportFraction: 1.0,
             aspectRatio: 0.75,
             clipBehavior: Clip.antiAlias,
             initialPage: widget.indexNo,
             padEnds: true,
             onPageChanged: (index, reason) {
               log('index $index');
               widget.indexNo = index;
               myUri = Uri.parse(File(widget.imgList[widget.indexNo]).path);
               setState(() {});
             },
           ),
         ),
       )
    );
  }
}
