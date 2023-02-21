// // ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print
//
// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:status_saver/app_theme/color.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
// import 'package:status_saver/controller/fileController.dart';
//
// class StatusImageDetailScreen extends StatefulWidget {
//   int indexNo;
//
//   StatusImageDetailScreen({Key? key, required this.indexNo}) : super(key: key);
//
//   @override
//   _StatusImageDetailScreenState createState() => _StatusImageDetailScreenState();
// }
//
// class _StatusImageDetailScreenState extends State<StatusImageDetailScreen> {
//   Uri? myUri;
//   FileController fileController = Get.put(FileController());
//   int currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.indexNo;
//     myUri = Uri.parse(fileController.allStatusImages.elementAt(widget.indexNo).filePath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
//     // imageData = savedImagesFolder!.map((e) => e.substring(37, 69).toString()).contains(widget.imgPath.substring(72, 104));
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: ColorsTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: ColorsTheme.black,
//         title: Text("Image"),
//         leading: IconButton(
//           color: ColorsTheme.white,
//           icon: Icon(
//             Icons.arrow_back_ios,
//           ),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Share.shareXFiles(
//                   text: "Have a look on this Status",
//                   [XFile(myUri!.path)],
//                 );
//               },
//               icon: Icon(Icons.share)),
//           Obx(() => Visibility(
//               visible: fileController.allStatusImages.elementAt(currentIndex).isSaved,
//               child: IconButton(
//                   onPressed: () {
//                     ReusingWidgets.snackBar(
//                         context: context, text: "Image Already Saved");
//                   },
//                   icon: Icon(Icons.done)))),
//           Obx(() => Visibility(
//               visible: !(fileController.allStatusImages.elementAt(currentIndex).isSaved),
//               child: IconButton(
//                   onPressed: () {
//                     GallerySaver.saveImage(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) {
//                       fileController.allStatusImages.elementAt(currentIndex).isSaved = true;
//                       fileController.allStatusImages.refresh();
//                     });
//                     ReusingWidgets.dialogueAnimated(
//                       context: context,
//                       dialogType: DialogType.success,
//                       color: ColorsTheme.primaryColor,
//                       title: "Image Saved",
//                       desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
//                     );
//                   },
//                   icon: Icon(Icons.save_alt)))),
//         ],
//       ),
//
//       // body: Hero(
//       //   tag: fileController.allStatusImages.elementAt(widget.indexNo).filePath,
//       //   child: Center(
//       //     child: Image.file(
//       //       File(fileController.allStatusImages.elementAt(widget.indexNo).filePath),
//       //       fit: BoxFit.cover,
//       //     ),
//       //   ),
//       // ),
//       body: Obx(()=> Container(
//         color: ColorsTheme.backgroundColor,
//         height: h,
//         child: CarouselSlider.builder(
//           itemCount: fileController.allStatusImages.length,
//           itemBuilder: (BuildContext context, int index,_) {
//             return InteractiveViewer(
//               panEnabled: true,
//               // boundaryMargin: EdgeInsets.all(0),
//               minScale: 0.5,
//               maxScale: 5,
//               child: Hero(
//                 tag: currentIndex,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.file(
//                       File(fileController.allStatusImages.elementAt(currentIndex).filePath),
//                       fit: BoxFit.fill,
//                       // width: double.infinity,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//           options: CarouselOptions(
//             animateToClosest: true,
//             autoPlay: false,
//             enlargeCenterPage: false,
//             enlargeFactor: 0,
//             enableInfiniteScroll: true,
//             disableCenter: false,
//             viewportFraction: 1.0,
//             aspectRatio: 0.75,
//             initialPage: currentIndex,
//             padEnds: true,
//             onPageChanged: (index, reason) {
//               log('index $index');
//               currentIndex = index;
//               myUri = Uri.parse(fileController.allStatusImages.elementAt(currentIndex).filePath);
//               setState(() {});
//             },
//             // onScrolled: (value){
//             //   print("object");
//             //   setState(() {});
//             // }
//           ),
//         ),
//       ),),
//     );
//   }
// }


/// //////////////////////////////
///
///

//
// // ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, avoid_print
//
// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:status_saver/app_theme/color.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
// import 'package:status_saver/controller/fileController.dart';
//
// class StatusImageDetailScreen extends StatefulWidget {
//   int indexNo;
//
//   StatusImageDetailScreen({Key? key, required this.indexNo}) : super(key: key);
//
//   @override
//   _StatusImageDetailScreenState createState() => _StatusImageDetailScreenState();
// }
//
// class _StatusImageDetailScreenState extends State<StatusImageDetailScreen> {
//   Uri? myUri;
//   FileController fileController = Get.put(FileController());
//   int currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.indexNo;
//     myUri = Uri.parse(fileController.allStatusImages.elementAt(widget.indexNo).filePath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
//     // imageData = savedImagesFolder!.map((e) => e.substring(37, 69).toString()).contains(widget.imgPath.substring(72, 104));
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: ColorsTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: ColorsTheme.black,
//         title: Text("Image"),
//         leading: IconButton(
//           color: ColorsTheme.white,
//           icon: Icon(
//             Icons.arrow_back_ios,
//           ),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Share.shareXFiles(
//                   text: "Have a look on this Status",
//                   [XFile(myUri!.path)],
//                 );
//               },
//               icon: Icon(Icons.share)),
//           Obx(() => Visibility(
//               visible: fileController.allStatusImages.elementAt(currentIndex).isSaved,
//               child: IconButton(
//                   onPressed: () {
//                     ReusingWidgets.snackBar(
//                         context: context, text: "Image Already Saved");
//                   },
//                   icon: Icon(Icons.done)))),
//           Obx(() => Visibility(
//               visible: !(fileController.allStatusImages.elementAt(currentIndex).isSaved),
//               child: IconButton(
//                   onPressed: () {
//                     GallerySaver.saveImage(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) {
//                       fileController.allStatusImages.elementAt(currentIndex).isSaved = true;
//                       fileController.allStatusImages.refresh();
//                     });
//                     ReusingWidgets.dialogueAnimated(
//                       context: context,
//                       dialogType: DialogType.success,
//                       color: ColorsTheme.primaryColor,
//                       title: "Image Saved",
//                       desc: "Image saved to File Manager > Internal Storage > >DCIM > StatusSaver",
//                     );
//                   },
//                   icon: Icon(Icons.save_alt)))),
//         ],
//       ),
//
//       // body: Hero(
//       //   tag: fileController.allStatusImages.elementAt(widget.indexNo).filePath,
//       //   child: Center(
//       //     child: Image.file(
//       //       File(fileController.allStatusImages.elementAt(widget.indexNo).filePath),
//       //       fit: BoxFit.cover,
//       //     ),
//       //   ),
//       // ),
//       body: Obx(()=> Container(
//         color: ColorsTheme.backgroundColor,
//         height: h,
//         child: Column(
//           children: [
//             CarouselSlider(
//               items: fileController.allStatusImages.map((index) {
//                 return Builder(
//                     builder: (BuildContext context) {
//                       return InteractiveViewer(
//                         panEnabled: true,
//                         // boundaryMargin: EdgeInsets.all(0),
//                         minScale: 0.5,
//                         maxScale: 5,
//                         child: Hero(
//                           tag: currentIndex,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 10,right: 10,top: 15),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Image.file(
//                                 File(fileController.allStatusImages.elementAt(currentIndex).filePath),
//                                 fit: BoxFit.fill,
//                                 // width: double.infinity,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 animateToClosest: true,
//                 autoPlay: false,
//                 enlargeCenterPage: false,
//                 enlargeFactor: 0,
//                 enableInfiniteScroll: true,
//                 disableCenter: false,
//                 viewportFraction: 1.0,
//                 aspectRatio: 0.75,
//                 initialPage: currentIndex,
//                 padEnds: true,
//                 onPageChanged: (index, reason) {
//                   log('index $index');
//                   currentIndex = index;
//                   myUri = Uri.parse(fileController.allStatusImages.elementAt(currentIndex).filePath);
//                   setState(() {});
//                 },
//                 // onScrolled: (value){
//                 //   print("object");
//                 //   setState(() {});
//                 // }
//               ),
//             ),
//             Container(
//                 height: w * 0.2,
//                 width: w * 0.25,
//                 child: ElevatedButton(onPressed: (){}, child: Icon(Icons.save_alt))),
//           ],
//         ),
//       ),),
//     );
//   }
// }



/// status image screen
///
///
///
/// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print
//
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:status_saver/app_theme/color.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
// import 'package:status_saver/app_theme/text_styles.dart';
// import 'package:status_saver/controller/fileController.dart';
// import 'package:status_saver/model/fileModel.dart';
// import 'statusImageDetailScreen.dart';
//
// class StatusImageScreen extends StatefulWidget {
//   const StatusImageScreen({Key? key}) : super(key: key);
//   @override
//   StatusImageScreenState createState() => StatusImageScreenState();
// }
//
// class StatusImageScreenState extends State<StatusImageScreen> {
//   int? storagePermissionCheck;
//   Future<int>? storagePermissionChecker;
//   int? androidSDK;
//   Directory? savedImagesDirectory;
//   // Directory? whatsAppBusinessDirectory;
//   final FileController fileController = Get.put(FileController());
//   List<String>? imageList;
//   List<String>? savedList;
//
//   Directory whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
//   Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//
//   Future<int> loadPermission() async {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     setState(() {
//       androidSDK = androidInfo.version.sdkInt;
//     });
//     if (androidSDK! >= 30) {
//       final currentStatusManaged = await Permission.manageExternalStorage.status;
//       if (currentStatusManaged.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     } else {
//       final currentStatusStorage = await Permission.storage.status;
//       if (currentStatusStorage.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     }
//   }
//
//   Future<int> requestPermission() async {
//     if (androidSDK! >= 30) {
//       final requestStatusManaged =
//       await Permission.manageExternalStorage.request();
//       if (requestStatusManaged.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     } else {
//       final requestStatusStorage = await Permission.storage.request();
//       if (requestStatusStorage.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     }
//   }
//
//   createFolder()async {
//     const folderName = "StatusSaver";
//     final path = Directory('/storage/emulated/0/DCIM/$folderName');
//     if ((await path.exists())) {
//       savedImagesDirectory = Directory('/storage/emulated/0/DCIM/$folderName');
//     }
//     else {
//       path.create();
//     }
//   }
//
//   getImageData(){
//     fileController.allStatusImages.value = [];
//     if(imageList!.isNotEmpty){
//       for (var element in imageList!) {
//         if(savedList!.map((e) => e.substring(37,69).toString()).contains(element.substring(72,104))){
//           // print("IF$element");
//           fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
//         }
//         else{
//           // print("ELSE$element");
//           fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
//         }
//       }
//     }
//   }
//
//   @override
//   void initState(){
//     super.initState();
//
//     imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
//     savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
//     // whatsAppBusinessDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
//
//     createFolder();
//     getImageData();
//     storagePermissionChecker = (() async {
//       int storagePermissionCheckInt;
//       int finalPermission;
//
//       if (storagePermissionCheck == null || storagePermissionCheck == 0) {
//         storagePermissionCheck = await loadPermission();
//       } else {
//         storagePermissionCheck = 1;
//       }
//       if (storagePermissionCheck == 1) {
//         storagePermissionCheckInt = 1;
//       } else {
//         storagePermissionCheckInt = 0;
//       }
//       if (storagePermissionCheckInt == 1) {
//         finalPermission = 1;
//       } else {
//         finalPermission = 0;
//       }
//       return finalPermission;
//     })();
//   }
//
//   Future pullRefresh() async {
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//      backgroundColor: ColorsTheme.backgroundColor,
//      body: FutureBuilder(
//        future: storagePermissionChecker,
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.done) {
//            if (snapshot.hasData) {
//              if (snapshot.data == 1) {
//                if (Directory(whatsAppDirectory.path).existsSync()) {
//                  if (fileController.allStatusImages.isNotEmpty) {
//                    return RefreshIndicator(
//                      backgroundColor: ColorsTheme.primaryColor,
//                      color: ColorsTheme.white,
//                      strokeWidth: 2,
//                      onRefresh: pullRefresh,
//                      child: Container(
//                          height: h,
//                          width: w,
//                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                          child: Obx(() => GridView.builder(
//                           // key: PageStorageKey(widget.key),
//                            itemCount: fileController.allStatusImages.length,
//                            physics: BouncingScrollPhysics(),
//                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                              crossAxisCount: 2,
//                              mainAxisSpacing: 5,
//                              crossAxisSpacing: 5,
//                              childAspectRatio: 0.75
//                            ),
//                            itemBuilder: (BuildContext context, int index) {
//                              return InkWell(
//                                onTap: () {
//                                  Get.to(()=> StatusImageDetailScreen(
//                                    indexNo: index,
//                                  ));
//                                },
//                                child:
//                                ReusingWidgets.getSavedData(
//                                  tag: fileController.allStatusImages.elementAt(index).filePath,
//                                  context: context,
//                                  file: File(fileController.allStatusImages.elementAt(index).filePath),
//                                  showPlayIcon: true,
//                                  bgColor: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                  ColorsTheme.primaryColor : ColorsTheme.doneColor,
//                                  icon:
//                                  fileController.allStatusImages.elementAt(index).isSaved == false
//                                      ? Icons.save_alt : Icons.done,
//                                  color: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                  ColorsTheme.white : ColorsTheme.doneColor,
//                                  onDownloadDeletePress: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                      (){
//                                    GallerySaver.saveImage(Uri.parse(
//                                        fileController.allStatusImages.elementAt(index).filePath).path,albumName: "StatusSaver",toDcim: true ).then((value) {
//                                          fileController.allStatusImages.elementAt(index).isSaved = true;
//                                          fileController.allStatusSaved.add(FileModel(
//                                            filePath: fileController.allStatusImages.elementAt(index).filePath,
//                                            isSaved: fileController.allStatusImages.elementAt(index).isSaved,));
//                                          fileController.allStatusImages.refresh();
//                                          fileController.allStatusSaved.refresh();
//
//                                    });
//                                    // ReusingWidgets.snackBar(context: context, text: "Image Saved");
//                                    ReusingWidgets.toast(text: "Image Saved");
//                                      }
//                                  : () {
//                                    // ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
//                                    ReusingWidgets.toast(text: "Image Already Saved");
//                                  },
//                                  onSharePress: () {
//                                    Share.shareXFiles(
//                                      text: "Have a look on this Status",
//                                      [XFile(Uri.parse(fileController.allStatusImages.elementAt(index).filePath).path)],
//                                    );
//                                  },
//                                ),
//
//                              ) ;
//                            },
//                          )),
//                      ),
//                    );
//                  } else {
//                    return Center(
//                      child: Text(
//                        'You have not watched any status yet!',
//                        style: ThemeTexts.textStyleTitle2,
//                      ),
//                    );
//                  }
//                }
//                else {
//                  return Center(
//                    child: Text(
//                      'No WhatsApp Found!',
//                      style: ThemeTexts.textStyleTitle3,
//                    ),
//                  );
//                }
//              }
//              else {
//                Future((){
//                  showDialog(
//                    context: context,
//                    barrierDismissible: false,
//                    builder: (context) => ReusingWidgets().permissionDialogue(
//                        context: context,
//                        width: w,
//                        height: h,
//                        onPress: (){
//                          setState(() {
//                            storagePermissionChecker = requestPermission();
//                            Navigator.pop(context);
//                          });
//                        }
//                    ),
//                  );
//                });
//                return Center(child: Padding(
//                  padding: EdgeInsets.all(30),
//                  child: ReusingWidgets.allowPermissionButton(
//                      onPress: (){
//                        setState(() {
//                          storagePermissionChecker = requestPermission();
//                        });
//                      },
//                      context: context,
//                      text: "Allow Permission"),
//                ));
//              }
//            }
//            else if (snapshot.hasError) {
//              return ReusingWidgets.circularProgressIndicator();
//            }
//            else {
//              return ReusingWidgets.circularProgressIndicator();
//            }
//          }
//          else {
//            return ReusingWidgets.circularProgressIndicator();
//          }
//        },
//      ),
//    );
//   }
// }


///status image screen with longpress
///
/// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print
//
// import 'dart:collection';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:status_saver/app_theme/color.dart';
// import 'package:status_saver/app_theme/reusing_widgets.dart';
// import 'package:status_saver/app_theme/text_styles.dart';
// import 'package:status_saver/controller/fileController.dart';
// import 'package:status_saver/model/fileModel.dart';
// import 'statusImageDetailScreen.dart';
//
// class StatusImageScreen extends StatefulWidget {
//   const StatusImageScreen({Key? key}) : super(key: key);
//   @override
//   StatusImageScreenState createState() => StatusImageScreenState();
// }
//
// class StatusImageScreenState extends State<StatusImageScreen> {
//   int? storagePermissionCheck;
//   Future<int>? storagePermissionChecker;
//   int? androidSDK;
//   Directory? savedImagesDirectory;
//   // Directory? whatsAppBusinessDirectory;
//   final FileController fileController = Get.put(FileController());
//   List<String>? imageList;
//   List<String>? savedList;
//
//   Directory whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
//   Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
//
//   Future<int> loadPermission() async {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     setState(() {
//       androidSDK = androidInfo.version.sdkInt;
//     });
//     if (androidSDK! >= 30) {
//       final currentStatusManaged = await Permission.manageExternalStorage.status;
//       if (currentStatusManaged.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     } else {
//       final currentStatusStorage = await Permission.storage.status;
//       if (currentStatusStorage.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     }
//   }
//
//   Future<int> requestPermission() async {
//     if (androidSDK! >= 30) {
//       final requestStatusManaged =
//       await Permission.manageExternalStorage.request();
//       if (requestStatusManaged.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     } else {
//       final requestStatusStorage = await Permission.storage.request();
//       if (requestStatusStorage.isGranted) {
//         return 1;
//       } else {
//         return 0;
//       }
//     }
//   }
//
//   createFolder()async {
//     const folderName = "StatusSaver";
//     final path = Directory('/storage/emulated/0/DCIM/$folderName');
//     if ((await path.exists())) {
//       savedImagesDirectory = Directory('/storage/emulated/0/DCIM/$folderName');
//     }
//     else {
//       path.create();
//     }
//   }
//
//   getImageData(){
//     fileController.allStatusImages.value = [];
//     if(imageList!.isNotEmpty){
//       for (var element in imageList!) {
//         if(savedList!.map((e) => e.substring(37,69).toString()).contains(element.substring(72,104))){
//           // print("IF$element");
//           fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
//         }
//         else{
//           // print("ELSE$element");
//           fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
//         }
//       }
//     }
//   }
//
//   @override
//   void initState(){
//     super.initState();
//
//     imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
//     savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
//     // whatsAppBusinessDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
//
//     createFolder();
//     getImageData();
//     storagePermissionChecker = (() async {
//       int storagePermissionCheckInt;
//       int finalPermission;
//
//       if (storagePermissionCheck == null || storagePermissionCheck == 0) {
//         storagePermissionCheck = await loadPermission();
//       } else {
//         storagePermissionCheck = 1;
//       }
//       if (storagePermissionCheck == 1) {
//         storagePermissionCheckInt = 1;
//       } else {
//         storagePermissionCheckInt = 0;
//       }
//       if (storagePermissionCheckInt == 1) {
//         finalPermission = 1;
//       } else {
//         finalPermission = 0;
//       }
//       return finalPermission;
//     })();
//   }
//
//   Future pullRefresh() async {
//     setState(() {});
//   }
//
//   HashSet selectItems = HashSet();
//   bool isMultiSelectionEnabled = false;
//
//   String getSelectedItemCount() {
//     return selectItems.isNotEmpty ? "${selectItems.length} item selected" : "No item selected";
//   }
//
//   doMultiSelection(int path) {
//     if (isMultiSelectionEnabled) {
//       setState(() {
//         if (selectItems.contains(path)) {
//           selectItems.remove(path);
//           print("hello");
//         } else {
//           selectItems.add(path);
//           print("adddd");
//         }
//       });
//     }
//     else {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorsTheme.primaryColor,
//         leading: isMultiSelectionEnabled
//             ? IconButton(
//             onPressed: () {
//               setState(() {
//                 isMultiSelectionEnabled = false;
//                 selectItems.clear();
//               });
//             },
//             icon: Icon(Icons.close))
//             : null,
//         title: Text(isMultiSelectionEnabled ? getSelectedItemCount() : "Status Saver"),
//         actions: [
//           // Visibility(
//           //     visible: isMultiSelectionEnabled,
//           //     child: IconButton(
//           //       onPressed: () {
//           //         setState(() {
//           //           if (selectItems.length == fileController.allStatusImages.length) {
//           //             selectItems.clear();
//           //           } else {
//           //             for (int index = 0; index < fileController.allStatusImages.length; index++) {
//           //               selectItems.add(fileController.allStatusImages[index]);
//           //             }
//           //           }
//           //         });
//           //       },
//           //       icon: Icon(
//           //         Icons.select_all,
//           //         color: (selectItems.length == fileController.allStatusImages.length)
//           //             ? Colors.black
//           //             : Colors.white,
//           //       ),
//           //     ))
//         IconButton(
//               onPressed: () {
//
//                 },
//               icon: Icon(
//                 Icons.downloading,
//                 color: ColorsTheme.white,
//               ),
//             )
//
//         ],
//       ),
//      backgroundColor: ColorsTheme.backgroundColor,
//      body: FutureBuilder(
//        future: storagePermissionChecker,
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.done) {
//            if (snapshot.hasData) {
//              if (snapshot.data == 1) {
//                if (Directory(whatsAppDirectory.path).existsSync()) {
//                  if (fileController.allStatusImages.isNotEmpty) {
//                    return RefreshIndicator(
//                      backgroundColor: ColorsTheme.primaryColor,
//                      color: ColorsTheme.white,
//                      strokeWidth: 2,
//                      onRefresh: pullRefresh,
//                      child: Container(
//                          height: h,
//                          width: w,
//                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                          child: Obx(() => GridView.builder(
//                           // key: PageStorageKey(widget.key),
//                            itemCount: fileController.allStatusImages.length,
//                            physics: BouncingScrollPhysics(),
//                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                              crossAxisCount: 2,
//                              mainAxisSpacing: 5,
//                              crossAxisSpacing: 5,
//                              childAspectRatio: 0.75
//                            ),
//                            itemBuilder: (BuildContext context, int index) {
//                              return InkWell(
//                                onTap: () {
//                                  // Get.to(()=> StatusImageDetailScreen(
//                                  //   indexNo: index,
//                                  // ));
//
//                                  doMultiSelection(index);
//                                },
//                                onLongPress: (){
//                                  isMultiSelectionEnabled = true;
//                                  print(index);
//                                  doMultiSelection(index);
//                                },
//                                child:
//                                ReusingWidgets.getSavedData(
//                                  tag: fileController.allStatusImages.elementAt(index).filePath,
//                                  context: context,
//                                  file: File(fileController.allStatusImages.elementAt(index).filePath),
//                                  showPlayIcon: true,
//                                  dummyWidget: true,
//                                  isVisible: selectItems.contains(index),
//                                  bgColor: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                  ColorsTheme.primaryColor : ColorsTheme.doneColor,
//                                  icon:
//                                  fileController.allStatusImages.elementAt(index).isSaved == false
//                                      ? Icons.save_alt : Icons.done,
//                                  color: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                  ColorsTheme.white : ColorsTheme.doneColor,
//                                  onDownloadDeletePress: fileController.allStatusImages.elementAt(index).isSaved == false ?
//                                      (){
//                                    GallerySaver.saveImage(Uri.parse(
//                                        fileController.allStatusImages.elementAt(index).filePath).path,albumName: "StatusSaver",toDcim: true ).then((value) {
//                                          fileController.allStatusImages.elementAt(index).isSaved = true;
//                                          fileController.allStatusSaved.add(FileModel(
//                                            filePath: fileController.allStatusImages.elementAt(index).filePath,
//                                            isSaved: fileController.allStatusImages.elementAt(index).isSaved,));
//                                          fileController.allStatusImages.refresh();
//                                          fileController.allStatusSaved.refresh();
//
//                                    });
//                                    // ReusingWidgets.snackBar(context: context, text: "Image Saved");
//                                    ReusingWidgets.toast(text: "Image Saved");
//                                      }
//                                  : () {
//                                    // ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
//                                    ReusingWidgets.toast(text: "Image Already Saved");
//                                  },
//                                  onSharePress: () {
//                                    Share.shareXFiles(
//                                      text: "Have a look on this Status",
//                                      [XFile(Uri.parse(fileController.allStatusImages.elementAt(index).filePath).path)],
//                                    );
//                                  },
//                                ),
//
//                              ) ;
//                            },
//                          )),
//                      ),
//                    );
//                  } else {
//                    return Center(
//                      child: Text(
//                        'You have not watched any status yet!',
//                        style: ThemeTexts.textStyleTitle2,
//                      ),
//                    );
//                  }
//                }
//                else {
//                  return Center(
//                    child: Text(
//                      'No WhatsApp Found!',
//                      style: ThemeTexts.textStyleTitle3,
//                    ),
//                  );
//                }
//              }
//              else {
//                Future((){
//                  showDialog(
//                    context: context,
//                    barrierDismissible: false,
//                    builder: (context) => ReusingWidgets().permissionDialogue(
//                        context: context,
//                        width: w,
//                        height: h,
//                        onPress: (){
//                          setState(() {
//                            storagePermissionChecker = requestPermission();
//                            Navigator.pop(context);
//                          });
//                        }
//                    ),
//                  );
//                });
//                return Center(child: Padding(
//                  padding: EdgeInsets.all(30),
//                  child: ReusingWidgets.allowPermissionButton(
//                      onPress: (){
//                        setState(() {
//                          storagePermissionChecker = requestPermission();
//                        });
//                      },
//                      context: context,
//                      text: "Allow Permission"),
//                ));
//              }
//            }
//            else if (snapshot.hasError) {
//              return ReusingWidgets.circularProgressIndicator();
//            }
//            else {
//              return ReusingWidgets.circularProgressIndicator();
//            }
//          }
//          else {
//            return ReusingWidgets.circularProgressIndicator();
//          }
//        },
//      ),
//    );
//   }
// }
