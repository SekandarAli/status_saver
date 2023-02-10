// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';

class ImageDetailScreen extends StatefulWidget {
  String imgPath;

  ImageDetailScreen({Key? key, required this.imgPath,}) : super(key: key);

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Image"),
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
                //
                // if (!Directory('/storage/emulated/0/WhatsApp Status Saver').existsSync()) {
                //   Directory('/storage/emulated/0/WhatsApp Status Saver').createSync(recursive: true);
                // }

                // final curDate = DateTime.now().toString();
                // final newFileName = '/storage/emulated/0/status_saver/VIDEO-$curDate.mp4';
                // final myUri = Uri.parse(widget.imgPath);
                // log(widget.imgPath);
                //
                //
                // final tempDir = await getTemporaryDirectory();
                // final path ="${tempDir.path}/myFile.jpg";
                //
                //
                // File aa = File(path);
                // log(aa.path.toString());
                // await Dio().download(widget.imgPath, path);
                //
                // GallerySaver.saveImage(myUri.path,albumName: "Status Saver");

                // final originalImageFile = File.fromUri(myUri);
                // log(myUri.toString());
                // late Uint8List bytes;
                //
                // await originalImageFile.readAsBytes().then((value) {
                //   bytes = Uint8List.fromList(value);
                // }).catchError((e) {
                //   print(e.toString());
                // });


                // await ImageGallerySaver.saveImage(Uint8List.fromList(bytes),quality: 100,name: "sss" );

                // var decoded = String.fromCharCodes(Uint8List.fromList(bytes));
                // log("asasas$decoded");
                // await GallerySaver.saveImage(decoded);


                final myUri = Uri.parse(widget.imgPath);
                GallerySaver.saveImage(myUri.path,albumName: "StatusSaver");

                ReusingWidgets.imageSavedDialogue(
                    context: context,
                    dialogType: DialogType.success,
                    color: ColorsTheme.primaryColor,
                    title: "Image Saved", desc: "Image saved to File Manager > Internal Storage > Pictures",
                    duration: 3000,
                );
              },
              icon: Icon(Icons.download)),
        ],
      ),
      body: Hero(
        tag: widget.imgPath,
        child: Center(
          child: Image.file(
            File(widget.imgPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
