import 'package:get/get.dart';

class ActiveAppController extends GetxController{

  RxInt activeApp = 1.obs;

  void changeActiveApp(int newActiveApp){
    activeApp.value = newActiveApp;
  }

}