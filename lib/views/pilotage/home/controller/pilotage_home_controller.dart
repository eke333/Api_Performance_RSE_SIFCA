import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class PilotageHomeController extends GetxController {
  final storage = const FlutterSecureStorage();

  void loadingPilotageHomeModel () async{
    // API :  email et hashPassWord
    // Result : email, nom, prenom
    final result = {
      "email":"fabricehouessou226@gmail",
      "nom":"HOUESSOU",
      "prenom":"Fabrice"
    };
  }

  Map<String,dynamic> getAccess() {
    // email,hashPassWord
    // Result : acces_evaluation,acces_pilotage,acces_reporting
    return {
      "acces_evaluation":false,
      "acces_pilotage":true,
      "acces_reporting":false,
    };
  }

  @override
  void onInit() {
    super.onInit();
    loadingPilotageHomeModel();
  }


}
