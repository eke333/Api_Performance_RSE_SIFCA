import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DropDownController extends GetxController {

  final storage = const FlutterSecureStorage();
  var filtreProcessus = <String>[].obs;

  void addRemoveProcessus(String processus, bool action ) async {
    if ( action == true ) {
      if ( !filtreProcessus.contains(processus) ) {
        filtreProcessus.add(processus);
      }
    } else {
      filtreProcessus.remove(processus);
    }
    if ( filtreProcessus.isNotEmpty ) {
      await storage.write(key: 'filtreProcessus', value: listToString(filtreProcessus));
    }
  }

  void effacerFiltreProcessus() async {
    filtreProcessus.value = [];
    await storage.delete(key: 'filtreProcessus');
  }

  String listToString(List<String> list) {
    return list.join(';');
  }

  List<String> stringToList(String text) {
    return text.split(";");
  }

  final jsonDropDown = {
    "axe_0":false,
    "axe_1":false,
    "axe_2":false,
    "axe_3":false,
    "axe_4":false
  }.obs;

  var filtreViewAxe = {
    "axe_0":true,
    "axe_1":true,
    "axe_2":true,
    "axe_3":true,
    "axe_4":true
  }.obs;

  void updateJson(String key, bool value) {
    jsonDropDown[key] = value;
  }

  void initialisation() async {
    String? kFiltreProcessus  = await storage.read(key: 'filtreProcessus');
    if (kFiltreProcessus != null && kFiltreProcessus.isNotEmpty ) {
      filtreProcessus.value = stringToList(kFiltreProcessus);
    }
  }

  @override
  void onInit() {
    initialisation();
    super.onInit();
  }




}