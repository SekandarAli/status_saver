import 'dart:developer';

import 'package:get/get.dart';
import 'package:status_saver/model/fileModel.dart';

class FileController extends GetxController{
  var allStatusImages = <FileModel>[].obs;
  var allStatusVideos = <FileModel>[].obs;
  var allStatusSaved = <FileModel>[].obs;

  // changeDownloadStatus(int index){
  //   allStatusImages.elementAt(index).isSaved = true;
  //   allStatusImages.forEach((element) {
  //     log(element.isSaved.toString());
  //   });
  //   allStatusImages.refresh();
  //   update();
  // }

}