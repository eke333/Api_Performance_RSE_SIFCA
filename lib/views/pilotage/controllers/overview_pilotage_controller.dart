import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/pilotage/contributeur_model.dart';
import '../../../utils/utils.dart';


class OverviewPilotageController extends GetxController {

  final supabase = Supabase.instance.client;

  var contributeurs = <ContributeurModel>[].obs;


  Future<bool> getAllUserEntite() async{
    try {
      List<ContributeurModel> listUserEntite = [];
      const storage = FlutterSecureStorage();
      String? email = await storage.read(key: 'email');
      if (email == null ) {
        return false;
      }
      final List userDocList = await supabase.from('Users').select().eq("email", email);
      final userDoc = userDocList.first;
      final usersList = await supabase.from('Users').select().eq("entreprise", userDoc["entreprise"]);
      final List<Map<String,dynamic>> accesPilotagesList = await supabase.from('AccesPilotage').select();

      for (var user in usersList ) {
        final accesPilotageJson = accesPilotagesList.firstWhere((element) => element["email"] == user["email"],orElse: null) ;
        final entite = accesPilotageJson == null ?  "----" : accesPilotageJson["nom_entite"] ;

        final acces = accesPilotageJson != null ? getAccesTypeUtils(AccesPilotageModel.fromJson(accesPilotageJson)) : "---" ;

        final kUser = ContributeurModel(
          entite:"${entite}",nom: user["nom"], prenom: user["prenom"], access: "${acces}", filiale: "${user["entreprise"]}",
        );

        listUserEntite.add(kUser);
      }

      contributeurs.value = listUserEntite;

      if ( contributeurs.isEmpty ) {
        return false ;
      }

      return true;

    } catch (e) {
      return false;
    }
  }
}