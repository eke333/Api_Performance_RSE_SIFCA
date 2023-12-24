import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../api/supabse_db.dart';
import '../../../controller/time_system_controller.dart';
import '../../../models/pilotage/data_indicateur_row_model.dart';
import '../../../models/pilotage/indicateur_model.dart';
import 'drop_down_controller.dart';
import 'entite_pilotage_controler.dart';
import 'profil_pilotage_controller.dart';
import 'package:http/http.dart' as http;

class TableauBordController extends GetxController {

  final DropDownController dropDownController = Get.find();

  final indicateursList = <IndicateurModel>[].obs;

  Map<String,dynamic>? dataMapExport  = null;
  final indicateursListApparente = <IndicateurModel>[].obs;

  final dataIndicateur = DataIndicateurRowModel.init().obs;

  final DataBaseController dataBaseController = DataBaseController();

  final ProfilPilotageController profilPilotageController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final statusIntialisation = false.obs;

  final triggerValeur = 0.obs;

  final isLoadingData = false.obs;
  final editing = false.obs;
  var currentYear = 0.obs;
  var currentMonth = 0.obs;
  var allYearsList = [].obs;

  var colonnesTableauBord = [
    "realise",
    "janvier",
    "fevrier",
    "mars",
    "avril",
    "mai",
    "juin",
    "juillet",
    "aout",
    "septembre",
    "octobre",
    "novembre",
    "decembre"
  ];

  var listMonth = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ];

  int getIndicateurLength() {
    return indicateursList.length;
  }


  void filtreListApparente() {
    if ( dropDownController.filtreProcessus.isEmpty ) {
      indicateursListApparente.value = indicateursList;
    } else {
      final List<IndicateurModel> _Klist = [];
      for (var indicateur in indicateursList ) {
        if (dropDownController.filtreProcessus.contains(indicateur.processus)) {
          _Klist.add(indicateur);
        }
      }
      indicateursListApparente.value = _Klist;
    }
  }

  void initDateTime() {
    var dateTime = TimeSystemController.date;
    currentYear.value = dateTime.year;
    currentMonth.value = dateTime.month;
  }



  void changeMonth(int month) {
    currentMonth.value = month;
  }

  bool changeYear(int year) {
    if (currentYear.value == year) {
      return false;
    }
    var dateTime = DateTime.now();
    if (year == dateTime.year) {
      currentYear.value = year;
      currentMonth.value = dateTime.month;
      return true;
    } else {
      currentYear.value = year;
      currentMonth.value = 12;
      return true;
    }
  }

  Future<Map<String, dynamic>?> loadDataExport(String entite,int annee) async {
    final result = await dataBaseController.getExportEntite(entite, annee);
    return result;
  }

  void initialisation(BuildContext context) async {
    allYearsList.value = TimeSystemController.years;
    final currentEntite = entitePilotageController.currentEntite.value;

    isLoading.value = true;
    indicateursList.value = await dataBaseController.getAllIndicateur();
    indicateursListApparente.value = indicateursList;
    dataIndicateur.value = await dataBaseController.getAllDataRowIndicateur("${currentEntite}", currentYear.value);
    if (dataIndicateur.value.entite != "" && dataIndicateur.value.annee !=0) {
      statusIntialisation.value = true;
      isLoading.value = false;
    } else {
      statusIntialisation.value = false;
      isLoading.value = false;
    }
  }


  void refreshData() async {
    allYearsList.value = TimeSystemController.years;
    final currentEntite = entitePilotageController.currentEntite.value;
    isLoading.value = false;
    indicateursList.value = await dataBaseController.getAllIndicateur();
    dataIndicateur.value = await dataBaseController.getAllDataRowIndicateur("${currentEntite}", currentYear.value);
    if (dataIndicateur.value.entite != "" && dataIndicateur.value.annee !=0) {
      statusIntialisation.value = true;
      isLoading.value = false;
    } else {
      statusIntialisation.value = false;
      isLoading.value = false;
    }
  }

  void updateDataIndicateur() async {
    final currentEntite = entitePilotageController.currentEntite.value;
    dataIndicateur.value = await dataBaseController.getAllDataRowIndicateur("${currentEntite}", currentYear.value);
  }

  Future<bool> renseignerIndicateurMois({required num valeur,required int numeroLigne,required int colonne,required String type,required String formule}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee":currentYear.value,
        "entite":"${currentEntite}",
        "valeur":valeur,
        "ligne":numeroLigne,
        "colonne":colonne,
        "type":type,
        "formule":formule,
      };

      const String apiUrl = "${DataBaseController.baseUrl}/data-entite-indicateur/update-data";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body:  jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createDataIndicateur(String idEntite, List<IndicateurModel> listIndicateurModel, BuildContext context) async {
    final annees = [2023];
    for (int an in annees) {
      var dataList = [];
      for (IndicateurModel indic in listIndicateurModel) {
        var row = {
          "_id": "${idEntite}_${an}_${indic.reference}",
          "entite": "${idEntite}",
          "annee": an,
          "numero_indicateur": indic.numero,
          "reference_indicateur": "${indic.reference}"
        };
        dataList.add(row);
        break;
      }
      await supabase.from('DataIndicateur').insert(dataList);
    }
    ;

    final location = GoRouter.of(context).location;
    context.go("/reload-page", extra: "${location}");
    return true;
  }

  Future<bool> validerIndicateurMois({required bool valide,required int numeroLigne,required int colonne}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee":currentYear.value,
        "entite":"${currentEntite}",
        "valide":valide,
        "ligne":numeroLigne,
        "colonne":colonne
      };

      const String apiUrl = "${DataBaseController.baseUrl}/data-entite-indicateur/update-validation";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body:  jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void triggerUpdateDataRow() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 120));
      refreshData();
    }
  }

  @override
  void onInit() async {
    initDateTime();
    triggerUpdateDataRow();
    super.onInit();
  }
}
