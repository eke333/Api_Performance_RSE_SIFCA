import 'package:get/get.dart';

class DropDownController {

  final jsonDropDown = {
    "axe_0":false,
    "axe_1":false,
    "axe_2":false,
    "axe_3":false,

   /* "axe_0":false,
    "axe_1":false,
    "axe_2":false,
    "axe_3":false,

    "axe_0":false,
    "axe_1":false,
    "axe_2":false,
    "axe_3":false,

    "axe_0":false,
    "axe_1":false,
    "axe_2":false,
    "axe_3":false,*/

  }.obs;

  void updateJson(String key, bool value) {
    jsonDropDown[key] = value;
  }
}