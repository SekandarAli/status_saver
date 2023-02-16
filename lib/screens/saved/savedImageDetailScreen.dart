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

  SavedImageDetailScreen({Key? key, required this.imgPath}) : super(key: key);

  @override
  _SavedImageDetailScreenState createState() => _SavedImageDetailScreenState();
}

class _SavedImageDetailScreenState extends State<SavedImageDetailScreen> {
  Uri? myUri;
  // bool? imageData;
  // List? savedImagesFolder;
  // Directory? savedImagesDirectory;
  FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    // myUri = Uri.parse(fileController.allStatusImages.elementAt(widget.indexNo).filePath);
    // savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver');
  }

  @override
  Widget build(BuildContext context) {
    print("dasda");
    // savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
    // imageData = savedImagesFolder!.map((e) => e.substring(37, 69).toString()).contains(widget.imgPath.substring(72, 104));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // toolbarHeight: 80,
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
          // Obx(() => Visibility(
          //     visible: fileController.allStatusImages.elementAt(widget.indexNo).isSaved,
          //     child: IconButton(
          //         onPressed: () {
          //           ReusingWidgets.snackBar(
          //               context: context, text: "Image Already Saved");
          //         },
          //         icon: Icon(Icons.done)))),
          // Obx(() => Visibility(
          //     visible: !(fileController.allStatusImages.elementAt(widget.indexNo).isSaved),
          //     child: IconButton(
          //         onPressed: () {
          //             GallerySaver.saveImage(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) {
          //               fileController.allStatusImages.elementAt(widget.indexNo).isSaved = true;
          //               fileController.allStatusImages.refresh();
          //             });
          //             ReusingWidgets.dialogueAnimated(
          //               context: context,
          //               dialogType: DialogType.success,
          //               color: ColorsTheme.primaryColor,
          //               title: "Image Saved",
          //               desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
          //             );
          //         },
          //         icon: Icon(Icons.save_alt)))),
        ],
      ),

      ///
      body: Hero(
        tag: widget.imgPath,
        child: Center(
          child: Image.file(
            widget.imgPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      // body: Obx(()=> CarouselSlider.builder(
      //   itemCount: fileController.allStatusImages.length,
      //   itemBuilder: (BuildContext context, int index,_) {
      //     return Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         // AppBar(
      //         //   // toolbarHeight: 80,
      //         //   backgroundColor: Colors.transparent,
      //         //   title: Text("Image"),
      //         //   leading: IconButton(
      //         //     color: ColorsTheme.white,
      //         //     icon: Icon(
      //         //       Icons.arrow_back_ios,
      //         //     ),
      //         //     onPressed: () => Navigator.of(context).pop(),
      //         //   ),
      //         //   actions: [
      //         //     IconButton(onPressed: () {
      //         //       Share.shareXFiles(
      //         //         text: "Have a look on this Status",
      //         //         [XFile(myUri!.path)],
      //         //       );
      //         //     }, icon: Icon(Icons.share)),
      //         //     imageData == true ?
      //         //     IconButton(
      //         //         onPressed: () {
      //         //           ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
      //         //         },
      //         //         icon: Icon(Icons.done)) :
      //         //     IconButton(
      //         //         onPressed: () {
      //         //           setState(() {
      //         //             GallerySaver.saveImage(myUri!.path,albumName: "StatusSaver",toDcim: true );
      //         //             ReusingWidgets.dialogueAnimated(
      //         //               context: context,
      //         //               dialogType: DialogType.success,
      //         //               color: ColorsTheme.primaryColor,
      //         //               title: "Image Saved",
      //         //               desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
      //         //             );
      //         //           });
      //         //
      //         //         },
      //         //         icon: Icon(Icons.save_alt)),
      //         //   ],
      //         // ),
      //         AppBar(
      //           // toolbarHeight: 80,
      //           backgroundColor: Colors.transparent,
      //           title: Text("Image"),
      //           leading: IconButton(
      //             color: ColorsTheme.white,
      //             icon: Icon(
      //               Icons.arrow_back_ios,
      //             ),
      //             // onPressed: () => Get.offAll(TabScreen()),
      //             onPressed: () => Get.back(),
      //           ),
      //           actions: [
      //             IconButton(
      //                 onPressed: () {
      //                   Share.shareXFiles(
      //                     text: "Have a look on this Status",
      //                     [XFile(myUri!.path)],
      //                   );
      //                 },
      //                 icon: Icon(Icons.share)),
      //             Obx(() => Visibility(
      //                 visible: fileController.allStatusImages.elementAt(widget.indexNo).isSaved,
      //                 child: IconButton(
      //                     onPressed: () {
      //                       ReusingWidgets.snackBar(
      //                           context: context, text: "Image Already Saved");
      //                     },
      //                     icon: Icon(Icons.done)))),
      //             Obx(() => Visibility(
      //                 visible: !(fileController.allStatusImages.elementAt(widget.indexNo).isSaved),
      //                 child: IconButton(
      //                     onPressed: () {
      //                       GallerySaver.saveImage(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) {
      //                         fileController.allStatusImages.elementAt(widget.indexNo).isSaved = true;
      //                         fileController.allStatusImages.refresh();
      //                       });
      //                       ReusingWidgets.dialogueAnimated(
      //                         context: context,
      //                         dialogType: DialogType.success,
      //                         color: ColorsTheme.primaryColor,
      //                         title: "Image Saved",
      //                         desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
      //                       );
      //                     },
      //                     icon: Icon(Icons.save_alt)))),
      //           ],
      //         ),
      //         Image.asset(
      //           fileController.allStatusImages.elementAt(widget.indexNo).filePath,
      //           fit: BoxFit.cover,
      //           // width: double.infinity,
      //         ),
      //       ],
      //     );
      //   },
      //   options: CarouselOptions(
      //     animateToClosest: false,
      //     autoPlay: false,
      //     enlargeCenterPage: true,
      //     // enableInfiniteScroll: false,
      //     // disableCenter: false,
      //     viewportFraction: 1.0,
      //     aspectRatio: 0.75,
      //     initialPage: widget.indexNo,
      //   ),
      // )),
    );
  }
}
