import 'package:get/get.dart';

class ActiveAppController extends GetxController{

  RxInt activeApp = 1.obs;

  Future<void> changeActiveApp(int newActiveApp) async {
    activeApp.value = newActiveApp;
  }

}