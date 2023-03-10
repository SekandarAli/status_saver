import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionController extends GetxController{
   RxBool permissionGrantedWhatsApp = false.obs;
   RxBool permissionGrantedBusinessWhatsApp = false.obs;

   changePermissionWhatsApp(bool newValue) async {
     permissionGrantedWhatsApp.value = newValue;
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool('isGrantedWhatsApp', newValue);
   }

   changePermissionBusinessWhatsApp(bool newValue) async {
     permissionGrantedBusinessWhatsApp.value = newValue;
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool('isGrantedBusinessWhatsApp', newValue);
   }
}