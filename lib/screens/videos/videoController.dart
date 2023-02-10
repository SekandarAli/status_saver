// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
   VideoController({Key? key, required this.videoPlayerController, required this.videoSrc, this.aspectRatio}) : super(key: key);

  VideoPlayerController videoPlayerController;
  String videoSrc;
  double? aspectRatio;

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {

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
      aspectRatio: widget.aspectRatio ?? widget.videoPlayerController.value.aspectRatio,
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

