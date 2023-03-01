// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, avoid_unnecessary_containers, library_private_types_in_public_api, null_check_always_fails, use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/screens/home/homeScreen.dart';
import '../app_theme/color.dart';
import '../app_theme/reusing_widgets.dart';
import '../controller/fileController.dart';
import '../drawer/drawerScreen.dart';
import '../model/fileModel.dart';
import '../screens/setting/settingScreen.dart';
import '../screens/whatsapp/saved/savedTabBar.dart';
import '../screens/whatsapp/status/statusTabBar.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
class _BottomNavBarScreenState extends State<BottomNavBarScreen> with TickerProviderStateMixin{

  int tabIndex = 0;
  late TabController tabController = TabController(length: 2, vsync: this,animationDuration: Duration(microseconds: 1));

  @override
  void initState() {
    super.initState();
    tabController.addListener(() {
      if (tabController.index == 0) {
        setState(() {
          tabIndex = 0;
          tabController.index = tabIndex;
        });
      }
      else if (tabController.index == 1) {
        setState(() {
          tabIndex = 1;
          tabController.index = tabIndex;
        });
      }
      else if (tabController.index == 2) {
        setState(() {
          tabIndex = 2;
          tabController.index = tabIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {

        if(scaffoldKey.currentState!.isDrawerOpen){
          scaffoldKey.currentState!.closeDrawer();
        }
      else if (tabController.index == 0) {
         // Get.offAll(()=> HomeScreen());
          ReusingWidgets.exitDialogueBox(
              context: context,
              onPress: (){
                Future.delayed(Duration(milliseconds: 1),() {
                  exit(0);
                });
              },
          );
      }
      else {
        tabIndex = 0;
        tabController.index = tabIndex;
      }
        return null!;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: DrawerScreen(),
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              color: ColorsTheme.white,
              height: 60,
              padding: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        tabIndex = 0;
                        tabController.index = tabIndex;
                      },
                      child: bottomWidget(
                        0,
                        "Status",
                        Icons.data_saver_on_sharp,
                        Icons.data_saver_off,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        tabIndex = 1;
                        tabController.index = tabIndex;
                      },
                      child: bottomWidget(
                        1,
                        "Saved",
                        Icons.save,
                        Icons.save_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: StatusTabScreen(),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: SavedTabScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget bottomWidget(int index, String title, IconData icon1, IconData icon2,) {
    return Column(
      children: [

        Icon(tabIndex == index ? icon1 : icon2,
          color: tabIndex == index
            ? ColorsTheme.primaryColor
            : ColorsTheme.lightGrey,),
        Text(
          title,
          style: TextStyle(
            color: tabIndex == index
                ? ColorsTheme.primaryColor
                : ColorsTheme.lightGrey,
          )
        )
      ],
    );
  }
}
