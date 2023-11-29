import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ContributeurScreen extends StatefulWidget {
  const ContributeurScreen({super.key});

  @override
  State<ContributeurScreen> createState() => _ContributeurScreenState();
}

class _ContributeurScreenState extends State<ContributeurScreen> {

  late ContributeurDataGridSource contributeurDataGridSource;

  final supabase = Supabase.instance.client;
  bool isLoading = false;


  Future<List<ContributeurModel>> getListContributeurs() async{
    setState(() {
      isLoading = true;
    });
    List dataMap = [];
    final List userResponse = await supabase.from("Users").select();
    final List accesPilotageResponse = await supabase.from("AccesPilotage").select();
    for (Map acces in accesPilotageResponse ){
      Map dataContributeur = {};
      dataContributeur["acces_pilotage"] = acces;
      Map? user = userResponse.firstWhere((element) => element["email"]==acces["email"],orElse: null);
      if (user!=null) {
        dataContributeur["email"] = user["email"];
        dataContributeur["nom"] = user["nom"];
        dataContributeur["prenom"] = user["prenom"];
        dataContributeur["fonction"] = user["fonction"];
        dataMap.add(dataContributeur);
      }
    }
    final listContribteurs = dataMap.map((json) => ContributeurModel.fromJson(json)).toList();
    setState(() {
      isLoading = false;
    });
    return listContribteurs;
  }


  void refreshData() async {
    final response = await getListContributeurs();
    setState(() {
      contributeurDataGridSource = ContributeurDataGridSource(contributeurs: response);
    });
  }

  late bool isWebOrDesktop;


  @override
  void initState() {
    super.initState();
    refreshData();
  }

  SfDataGridTheme  _buildDataGridForWeb() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: Brightness.light,
          rowHoverColor: Colors.amber.withOpacity(0.5),
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: Colors.blue),
      child: SfDataGrid(
        source: contributeurDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        columns: <GridColumn>[
          GridColumn(
              width: 130,
              columnName: 'nom',
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Nom',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridColumn(
            columnName: 'prenom',
            width: 150,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Prénom',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'mail',
            width: 250.0,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'E-mail',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'entite',
            width: 150.0,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Entité',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
              columnName: 'acces',
              width: 200,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Accès',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'filiale',
              width: 165,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Filiale',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
            columnName: 'filiere',
            width: 165,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Filière',
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          GridColumn(
            columnName: 'processus',
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Processus',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'fonction',
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Fonction',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget actionWidget() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onHover: (value){},
          onTap: () async {
            final response = await getListContributeurs();
            setState(() {
              contributeurDataGridSource = ContributeurDataGridSource(contributeurs: response);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child: const Row(
             children: [
               Icon(Icons.refresh_sharp,size: 25,color: Colors.green),
               SizedBox(width: 5,),
               Text("Rafraîchir")
             ],
            ),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onHover: (value){},
          onTap: (){},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.filter_alt_rounded,size: 25,color: Colors.green,),
                SizedBox(width: 5,),
                Text("Filtrer")
              ],
            ),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onHover: (value){},
          onTap: (){},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.sort,size: 25,color: Colors.green,),
                SizedBox(width: 5,),
                Text("Trier")
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        ElevatedButton(onPressed: (){},
        child : const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 10,),
            Text("Ajouter")
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: isLoading ? loadingPageWidget() : Column(
        children: [
          Container(height: 40,child: actionWidget(),),
          const SizedBox(height: 5,),
          Expanded(child: _buildDataGridForWeb())
        ],
      ),
    );
  }
}


class ContributeurDataGridSource extends DataGridSource {

  ContributeurDataGridSource({required List<ContributeurModel> contributeurs}) {
     _contributeurs = contributeurs;
      buildDataGridRow();
  }

  List<ContributeurModel> _contributeurs = <ContributeurModel>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];


  void buildDataGridRow() {
    dataGridRows = _contributeurs.map<DataGridRow>((ContributeurModel contributeur) {
        return DataGridRow(cells: <DataGridCell>[
          DataGridCell<String>(columnName: 'nom', value: contributeur.nom),
          DataGridCell<String>(columnName: 'prenom', value: contributeur.prenom),
          DataGridCell<String>(columnName: 'mail', value: contributeur.email),
          DataGridCell<String>(columnName: 'entite', value: contributeur.accesPilotageModel?.nomEntite),
          DataGridCell<AccesPilotageModel>(columnName: 'acces', value: contributeur.accesPilotageModel),
          DataGridCell<String>(columnName: 'filiale', value: contributeur.accesPilotageModel?.entite),
          DataGridCell<String>(columnName: 'filiere', value: contributeur.accesPilotageModel?.entite),
          DataGridCell<String>(columnName: 'processus', value: contributeur.accesPilotageModel?.processus),
          DataGridCell<String>(columnName: 'fonction', value: contributeur.fonction),
        ]);
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
          switch (dataCell.columnName) {
            case "acces":
              return Container(
                padding: const EdgeInsets.only(left: 8.0),
                alignment: Alignment.centerLeft,
                child: getAcces(dataCell.value),
              );
            default :
              return Container(
                padding: const EdgeInsets.only(left: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(dataCell.value.toString()),
              );
          }
        }).toList());
  }

  Widget getAcces(AccesPilotageModel acces) {
    if (acces.estBloque == true) {
      return const Text("Est bloqué",style: TextStyle(color: Colors.red),);
    }
    if (acces.estAdmin == true) {
      return const Text("Admin",style: TextStyle(color: Colors.green),);
    }
    if (acces.estValidateur == true) {
      return const Text("Validateur",style: TextStyle(color: Colors.blue),);
    }
    if (acces.estEditeur == true) {
      return const Text("Editeur",style: TextStyle(color: Colors.black),);
    }
    if (acces.estSpectateur == true) {
      return const Text("Spectateur",style: TextStyle(color: Colors.grey),);
    }
    return Container();
  }


}


class ContributeurModel {

  String? email;
  String? nom;
  String? prenom;
  String? fonction;
  AccesPilotageModel? accesPilotageModel;

  ContributeurModel({
    this.email,
    this.nom,
    this.prenom,
    this.fonction,
    this.accesPilotageModel,
  });

  factory ContributeurModel.fromRawJson(String str) => ContributeurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContributeurModel.fromJson(Map<dynamic, dynamic> json) => ContributeurModel(
    email: json["email"],
    nom: json["nom"],
    prenom: json["prenom"],
    fonction: json["fonction"],
    accesPilotageModel: AccesPilotageModel.fromJson(json["acces_pilotage"]),
  );

  Map<String, dynamic> toJson() => {
    "email": nom,
    "nom": nom,
    "prenom": prenom,
    "fonction": fonction,
    "acces_pilotage": accesPilotageModel?.toJson(),
  };

}
