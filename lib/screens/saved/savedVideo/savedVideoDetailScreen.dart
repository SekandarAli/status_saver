// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../../app_theme/color.dart';
import '../../../../app_theme/reusing_widgets.dart';
import '../../../../controller/active_app_controller.dart';
import '../../../../controller/fileController.dart';

class SavedVideoDetailScreen extends StatefulWidget {
  File videoPath;
  List videoList;
  int indexNo;

  SavedVideoDetailScreen({Key? key, required this.videoPath,required this.indexNo,required this.videoList}) : super(key: key);

  @override
  _SavedVideoDetailScreenState createState() => _SavedVideoDetailScreenState();
}

class _SavedVideoDetailScreenState extends State<SavedVideoDetailScreen> {

  FileController fileController = Get.put(FileController());
  ActiveAppController activeAppController = Get.put(ActiveAppController());

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Saved Video"),
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles(text: "Have a look on this Status",
                  [XFile(widget.videoPath.path.replaceAll("%20"," "))],);
          },
              icon: Icon(Icons.share)),
          IconButton(onPressed: () {

            activeAppController.activeApp.value == 1 ?
            setState(() {
              File(widget.videoList[widget.indexNo]).delete();
              for (var element in fileController.allStatusVideos) {
                if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                contains(  File(widget.videoList[widget.indexNo]).toString().split("StatusSaver/").last.split(".").first)){
                  element.isSaved = false;
                }
              }
            }) :
            setState(() {
              File(widget.videoList[widget.indexNo]).delete();
              for (var element in fileController.allStatusVideos) {
                if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                contains( File(widget.videoList[widget.indexNo]).toString().split("StatusSaverBusiness/").last.split(".").first)){
                  element.isSaved = false;
                }
              }
            });
            ReusingWidgets.toast(text: "Video Deleted Successfully!");
            Navigator.pop(context);

          }, icon: Icon(Icons.delete,color: ColorsTheme.dismissColor,)),
        ],
      ),
      body: SavedController(
        videoPlayerController: VideoPlayerController.file(widget.videoPath),
      ),
    );
  }
}

class SavedController extends StatefulWidget {
  SavedController({Key? key, required this.videoPlayerController}) : super(key: key);

  VideoPlayerController videoPlayerController;

  @override
  State<SavedController> createState() => _SavedControllerState();
}

class _SavedControllerState extends State<SavedController> {

  ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      looping: true,
      allowFullScreen: true,
      autoPlay: true,
      showOptions: false,
      // aspectRatio: widget.aspectRatio ?? widget.videoPlayerController.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 0),
        child: Chewie(
          controller: chewieController!,
        ),
      ),
    );
  }
}



