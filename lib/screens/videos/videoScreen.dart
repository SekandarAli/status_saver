// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../app_theme/text_styles.dart';
import 'videoDetailScreen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {

  Directory? whatsAppDirectory;
  Directory? whatsAppBusinessDirectory;

  @override
  void initState() {
    whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
    whatsAppBusinessDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
    super.initState();
  }

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (Directory(whatsAppDirectory!.path).existsSync()) {
      final videoList = whatsAppDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
        if (videoList.isNotEmpty) {
          return Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GridView.builder(
                key: PageStorageKey(widget.key),
                itemCount: videoList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VideoDetailScreen(
                        videoFile: videoList[index],
                      ),
                    ),
                    ),
                    child: FutureBuilder(
                        future: getVideo(videoList[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Stack(
                                alignment: Alignment.center,
                                fit: StackFit.loose,
                                children: [
                                  Hero(
                                    tag: videoList[index],
                                    child: Container(
                                      height: h,
                                      width: w,
                                      color: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.5)
                                    ),
                                      child: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 40,
                                          color: ColorsTheme.white,
                                      ),
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          } else {
                            return Hero(
                              tag: videoList[index],
                              child: Image.asset(Assets.imagesVideoLoader,fit: BoxFit.cover,width: 30,height: 30),
                            );
                          }
                        }),
                  );
                },
              ),
            ),
          );
        }
        else {
          return Center(
            child: Text(
              'Sorry, No Videos Found.',
              style: ThemeTexts.textStyleTitle2,
            ),
          );
        }
    }
    else {
      return Center(
        child: Text(
          'No WhatsApp Found!',
          style: ThemeTexts.textStyleTitle3,
        ),
      );
    }
  }
}
