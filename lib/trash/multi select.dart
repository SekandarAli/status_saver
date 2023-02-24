//
//
//
//
//
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<String> imagePaths = [
//     'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
//     'https://images.unsplash.com/photo-1580777187326-d45ec82084d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
//     'https://images.unsplash.com/photo-1531804226530-70f8004aa44e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
//     'https://images.unsplash.com/photo-1465056836041-7f43ac27dcb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
//     'https://images.unsplash.com/photo-1573553256520-d7c529344d67?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
//   ];
//
//   HashSet selectItems = HashSet();
//   bool isMultiSelectionEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: isMultiSelectionEnabled
//               ? IconButton(
//               onPressed: () {
//                 setState(() {
//                   isMultiSelectionEnabled = false;
//                   selectItems.clear();
//                 });
//               },
//               icon: Icon(Icons.close))
//               : null,
//           title: Text(isMultiSelectionEnabled ? getSelectedItemCount() : "Select/Unselect All"),
//           actions: [
//             Visibility(
//                 visible: isMultiSelectionEnabled,
//                 child: IconButton(
//                   onPressed: () {
//                     setState(() {
//                       if (selectItems.length == imagePaths.length) {
//                         selectItems.clear();
//                       } else {
//                         for (int index = 0; index < imagePaths.length; index++) {
//                           selectItems.add(imagePaths[index]);
//                         }
//                       }
//                     });
//                   },
//                   icon: Icon(
//                     Icons.select_all,
//                     color: (selectItems.length == imagePaths.length)
//                         ? Colors.black
//                         : Colors.white,
//                   ),
//                 ))
//           ],
//         ),
//         body: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 2,
//           childAspectRatio: 1.5,
//           children: imagePaths.map((String path) {
//             return GridTile(
//               child: InkWell(
//                 onTap: () {
//                   print(path);
//                   doMultiSelection(path);
//                 },
//                 onLongPress: () {
//                   isMultiSelectionEnabled = true;
//                   doMultiSelection(path);
//                 },
//                 child: Stack(
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Expanded(
//                             child: Image.network(
//                               path,
//                               color: Colors.black.withOpacity(selectItems.contains(path) ? 1 : 0),
//                               colorBlendMode: BlendMode.color,
//                             )),
//                       ],
//                     ),
//                     Visibility(
//                         visible: selectItems.contains(path),
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ));
//   }
//
//   String getSelectedItemCount() {
//     return selectItems.isNotEmpty ? "${selectItems.length} item selected" : "No item selected";
//   }
//
//    doMultiSelection(String path) {
//     if (isMultiSelectionEnabled) {
//       setState(() {
//         if (selectItems.contains(path)) {
//           selectItems.remove(path);
//           print("hello");
//         } else {
//           selectItems.add(path);
//           print("add");
//         }
//       });
//     }
//     else {}
//   }
//
// }

///open whatsapp or b-wa

// Tooltip(
// message: "Open Business WhatsApp",
// child: GestureDetector(
// onTap: ()async {
// try {
// bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
// if (isInstalled) {
// DeviceApps.openApp("com.whatsapp.w4b").then((value){
// ReusingWidgets.toast(text: "Opening Business WhatsApp...");
// });
// }
// else {
// launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
// }
// } catch (e) {
// ReusingWidgets.toast(text: e.toString());
// }
// },
// child: Image.asset(Assets.imagesWhatsappBusinessIcon,height: 30,width: 30,)),
// ),