import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  ContributeurDataGridSource contributeurDataGridSource = ContributeurDataGridSource(contributeurs: []);

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  List<String> entitesName = [];
  List<String> entitesId = [];
  List<String> filiales = [];

  void loadEntite() async {
    final List response = await supabase.from("Entites").select();
    for (var data in response) {
      entitesName.add(data["nom_entite"]);
      entitesId.add(data["id_entite"]);
      filiales.add(data["filiale"]);
    }
  }

  Future<List<ContributeurModel>> getListContributeurs() async {
    setState(() {
      isLoading = true;
    });
    List dataMap = [];
    final List userResponse = await supabase.from("Users").select();
    final List accesPilotageResponse = await supabase.from("AccesPilotage").select();
    for (Map acces in accesPilotageResponse) {
       Map dataContributeur = {};
       dataContributeur["acces_pilotage"] = acces;
       var user;
       try {
         user = userResponse.firstWhere((element) => element["email"] == acces["email"],orElse: () => null);
       } catch (e) {
         user = null;
       }

       if (user != null) {
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
    refreshData();
    loadEntite();
    super.initState();
  }

  SfDataGridTheme _buildDataGridForWeb() {
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
          onHover: (value) {},
          onTap: () async {
            refreshData();
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.refresh_sharp, size: 25, color: Colors.green),
                SizedBox(
                  width: 5,
                ),
                Text("Rafraîchir")
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        ElevatedButton(
            onPressed: () {
              if (entitesName.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Ajouter un contributeur",
                        style: TextStyle(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      titlePadding:
                          const EdgeInsets.only(top: 20, right: 20, left: 20),
                      titleTextStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      content: AjoutContributeur(
                        entitesName: entitesName,
                        entitesId: entitesId,
                        filiales: filiales,
                      ),
                    );
                  },
                );
              }
            },
            child: const Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 10,
                ),
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
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: actionWidget(),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(child: isLoading ? const Center(child: CircularProgressIndicator()) : _buildDataGridForWeb())
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
    dataGridRows =
        _contributeurs.map<DataGridRow>((ContributeurModel contributeur) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'nom', value: contributeur.nom),
        DataGridCell<String>(columnName: 'prenom', value: contributeur.prenom),
        DataGridCell<String>(columnName: 'mail', value: contributeur.email),
        DataGridCell<String>(
            columnName: 'entite',
            value: contributeur.accesPilotageModel?.nomEntite),
        DataGridCell<AccesPilotageModel>(
            columnName: 'acces', value: contributeur.accesPilotageModel),
        DataGridCell<String>(
            columnName: 'filiale',
            value: contributeur.accesPilotageModel?.entite),
        DataGridCell<String>(
            columnName: 'filiere',
            value: contributeur.accesPilotageModel?.entite),
        DataGridCell<String>(
            columnName: 'processus',
            value: contributeur.accesPilotageModel?.processus),
        DataGridCell<String>(
            columnName: 'fonction', value: contributeur.fonction),
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
        default:
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
      return const Text(
        "Est bloqué",
        style: TextStyle(color: Colors.red),
      );
    }
    if (acces.estAdmin == true) {
      return const Text(
        "Admin",
        style: TextStyle(color: Colors.green),
      );
    }
    if (acces.estValidateur == true) {
      return const Text(
        "Validateur",
        style: TextStyle(color: Colors.blue),
      );
    }
    if (acces.estEditeur == true) {
      return const Text(
        "Editeur",
        style: TextStyle(color: Colors.black),
      );
    }
    if (acces.estSpectateur == true) {
      return const Text(
        "Spectateur",
        style: TextStyle(color: Colors.grey),
      );
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

  factory ContributeurModel.fromRawJson(String str) =>
      ContributeurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContributeurModel.fromJson(Map<dynamic, dynamic> json) =>
      ContributeurModel(
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

class AjoutContributeur extends StatefulWidget {
  final List<String> entitesName;
  final List<String> entitesId;
  final List<String> filiales;
  const AjoutContributeur(
      {super.key,
      required this.entitesName,
      required this.entitesId,
      required this.filiales});

  @override
  State<AjoutContributeur> createState() => _AjoutContributeurState();
}

class _AjoutContributeurState extends State<AjoutContributeur> {
  final supabase = Supabase.instance.client;

  bool isSubmetted = false;

  List<DropdownMenuItem<String>> _dropDownMenuItems = [];

  static const listTitres = ["M.", "Mme", "Mlle"];
  static const listAcces = ["Spectateur", "Editeur", "Validateur", "Admin"];

  Map accesToDoc = {
    "Spectateur": "est_spectateur",
    "Editeur": "est_editeur",
    "Validateur": "est_validateur",
    "Admin": "est_admin"
  };

  String? entiteName;
  String? titre;
  String? acces;

  void initialisation() {
    final dropDown = widget.entitesName
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();
    setState(() {
      _dropDownMenuItems = dropDown;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<String>> _dropDownMenuAcces = listAcces
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final List<DropdownMenuItem<String>> _dropDownMenuTitre = listTitres
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController nomEditingController = TextEditingController();
  final TextEditingController prenomEditingController = TextEditingController();

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: emailEditingController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !GetUtils.isEmail(value)) {
                      return '...';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: nomEditingController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return '...';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Nom",
                    labelText: "Nom",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: prenomEditingController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return '...';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Prénom(s)",
                    labelText: "Prénom(s)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: const Text("M./Mme/Mlle"),
                trailing: DropdownButton(
                  menuMaxHeight: 400,
                  value: titre,
                  hint: const Text('Titre'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => titre = newValue);
                    }
                  },
                  items: _dropDownMenuTitre,
                ),
              ),
              ListTile(
                title: const Text("Espace pilotage"),
                trailing: DropdownButton(
                  menuMaxHeight: 400,
                  value: entiteName,
                  hint: const Text('Espace'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => entiteName = newValue);
                    }
                  },
                  items: _dropDownMenuItems,
                ),
              ),
              ListTile(
                title: const Text("Le type d'accès"),
                trailing: DropdownButton(
                  menuMaxHeight: 400,
                  value: acces,
                  hint: const Text('Choose'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => acces = newValue);
                    }
                  },
                  items: _dropDownMenuAcces,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Renseigner bien tous les champs avant de soumettre ",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    child: isSubmetted ? const CircularProgressIndicator() : null,
                  ),
                  ElevatedButton(
                      onPressed: isSubmetted
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate() &&
                                  titre != null &&
                                  entiteName != null &&
                                  acces != null) {
                                setState(() {
                                  isSubmetted = true;
                                });

                                final index =
                                    widget.entitesName.indexOf(entiteName!);
                                final filiale = widget.filiales[index];
                                final idEntite = widget.entitesId[index];

                                final userMap = {
                                  "email": emailEditingController.text,
                                  "nom": nomEditingController.text,
                                  "prenom": prenomEditingController.text,
                                  "acces_pilotage": emailEditingController.text,
                                  "entreprise": filiale,
                                  "est_bloque": false,
                                  "titre": titre,
                                };

                                final userAcces = {
                                  "email": emailEditingController.text,
                                  "entite": idEntite,
                                  "nom_entite": entiteName,
                                  "est_bloque": false,
                                  "est_spectateur": false,
                                  "est_editeur": false,
                                  "est_validateur": false,
                                  "restrictions": [],
                                  "est_admin": false,
                                };

                                userAcces[accesToDoc[acces]] = true;

                                try {
                                  final res1 = await supabase
                                      .from('Users')
                                      .insert(userMap);

                                  final res2 = await supabase
                                      .from('AccesPilotage')
                                      .insert(userAcces);

                                  String pwd = generatePassword();
                                  final AuthResponse res3 = await supabase.auth
                                      .signUp(
                                          email: emailEditingController.text,
                                          password: pwd,
                                          data: {"password": pwd});
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 10),
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        e.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }

                                setState(() {
                                  isSubmetted = false;
                                });

                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Le compte ${emailEditingController.text} a été crée .',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }
                            },
                      child: const Text('Soumettre'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String generatePassword() {
    const String validChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#';

    Random random = Random();
    String password = '';

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(validChars.length);
      password += validChars[randomIndex];
    }

    return password;
  }
}
