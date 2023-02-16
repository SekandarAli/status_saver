// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/model/fileModel.dart';
import 'package:status_saver/screens/tabScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
        GetMaterialApp(home: MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;
  // FileModel? fileImages;
  Directory whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
  Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
  final FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    // fileImages = FileModel(filePath: whatsAppDirectory.path, isSaved: true);
    imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
    videoList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
    getSavedData();

  }
  getImageData(){
    // fileController.allStatusImages.value = [];
    if(imageList.isNotEmpty){
      for (var element in imageList) {
        if(savedList.map((e) => e.substring(37,69).toString()).contains(element.substring(72,104))){
          // print("IF$element");
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
        }
        else{
          // print("ELSE$element");
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  getVideoData(){
    // fileController.allStatusImages.value = [];
    if(videoList.isNotEmpty){
      for (var element in videoList) {
        if(savedList.map((e) => e.substring(37,69).toString()).contains(element.substring(72,104))){
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
        }
        else{
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  getSavedData(){
    // fileController.allStatusImages.value = [];
    if(savedList.isNotEmpty){
      for (var element in savedList) {
        if(savedList.contains(element)){
          fileController.allStatusSaved.add(FileModel(filePath: element, isSaved: true));
        }
        else{
          fileController.allStatusSaved.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabScreen(),
      // home: CarouselPage()
      // home: HomeScreen(),
    );
  }
}