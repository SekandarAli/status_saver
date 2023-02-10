// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../app_theme/color.dart';
import '../../app_theme/reusing_widgets.dart';
import 'videoController.dart';

class VideoDetailScreen extends StatefulWidget {
  String videoFile;
  VideoDetailScreen({Key? key, required this.videoFile,}) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(
              onPressed: () async {
                final originalVideoFile = File(widget.videoFile);
                if (!Directory('/storage/emulated/0/status_saver').existsSync()) {
                  Directory('/storage/emulated/0/status_saver').createSync(recursive: true);
                }
                final curDate = DateTime.now().toString();
                final newFileName = '/storage/emulated/0/status_saver/VIDEO-$curDate.mp4';
                await originalVideoFile.copy(newFileName);

                ReusingWidgets.imageSavedDialogue(
                  context: context,
                  dialogType: DialogType.success,
                  color: ColorsTheme.primaryColor,
                  title: "Video Saved", desc: "Video saved to File Manager > Internal Storage > Pictures",
                  duration: 3000,
                );
              },
              icon: Icon(Icons.download)),
        ],
      ),
      body: VideoController(
        videoPlayerController:
        VideoPlayerController.file(File(widget.videoFile)),
        videoSrc: widget.videoFile,
      ),
    );
  }
}
