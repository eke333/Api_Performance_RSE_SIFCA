import 'dart:convert';

class DataIndicateurModel {
  final String? idEntite;
  final String? entite;
  final int? annee;
  final List<DataRowModel>? realise;
  final List<DataRowModel>? janvier;
  final List<DataRowModel>? fevrier;
  final List<DataRowModel>? mars;
  final List<DataRowModel>? avril;
  final List<DataRowModel>? mai;
  final List<DataRowModel>? juin;
  final List<DataRowModel>? juillet;
  final List<DataRowModel>? aout;
  final List<DataRowModel>? septembre;
  final List<DataRowModel>? octobre;
  final List<DataRowModel>? novembre;
  final List<DataRowModel>? decembre;

  DataIndicateurModel({
    this.idEntite,
    this.entite,
    this.annee,
    this.realise,
    this.janvier,
    this.fevrier,
    this.mars,
    this.avril,
    this.mai,
    this.juin,
    this.juillet,
    this.aout,
    this.septembre,
    this.octobre,
    this.novembre,
    this.decembre,
  });

  factory DataIndicateurModel.fromRawJson(String str) => DataIndicateurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataIndicateurModel.fromJson(Map<String, dynamic> json) => DataIndicateurModel(
    idEntite: json["id_entite"],
    entite: json["entite"],
    annee: json["annee"],
    realise: List<DataRowModel>.from(json["realise"].map((x) => DataRowModel.fromJson(x))),
    janvier: List<DataRowModel>.from(json["janvier"].map((x) => DataRowModel.fromJson(x))),
    fevrier: List<DataRowModel>.from(json["fevrier"].map((x) => DataRowModel.fromJson(x))),
    mars: List<DataRowModel>.from(json["mars"].map((x) => DataRowModel.fromJson(x))),
    avril: List<DataRowModel>.from(json["avril"].map((x) => DataRowModel.fromJson(x))),
    mai: List<DataRowModel>.from(json["mai"].map((x) => DataRowModel.fromJson(x))),
    juin: List<DataRowModel>.from(json["juin"].map((x) => DataRowModel.fromJson(x))),
    juillet: List<DataRowModel>.from(json["juillet"].map((x) => DataRowModel.fromJson(x))),
    aout: List<DataRowModel>.from(json["aout"].map((x) => DataRowModel.fromJson(x))),
    septembre: List<DataRowModel>.from(json["septembre"].map((x) => DataRowModel.fromJson(x))),
    octobre: List<DataRowModel>.from(json["octobre"].map((x) => DataRowModel.fromJson(x))),
    novembre: List<DataRowModel>.from(json["novembre"].map((x) => DataRowModel.fromJson(x))),
    decembre: List<DataRowModel>.from(json["decembre"].map((x) => DataRowModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id_entite": idEntite,
    "entite": entite,
    "annee": annee,
    "realise": realise,
    "janvier": janvier,
    "fevrier": fevrier,
    "mars": mars,
    "avril": avril,
    "mai": mai,
    "juin": juin,
    "juillet": juillet,
    "aout": aout,
    "septembre": septembre,
    "octobre": octobre,
    "novembre": novembre,
    "decembre": decembre,
  };
}

class DataTableauBord{
  String? entite;
  List<List<DataRowModel>>? anneeC;
  List<List<DataRowModel>>? anneeB;
  List<List<DataRowModel>>? anneeA;

  DataTableauBord({
    required this.entite,
    required this.anneeC,
    required this.anneeB,
    required this.anneeA,
  });
  factory DataTableauBord.init() => DataTableauBord(entite: null,anneeA: null,anneeB: null,anneeC: null);
}

class DataRowModel {
  String idIndicateur;
  int numero;
  String colonne;
  num? value;
  bool estValide;

  DataRowModel({
    required this.idIndicateur,
    required this.numero,
    required this.value,
    required this.colonne,
    required this.estValide,
  });

  factory DataRowModel.fromRawJson(String str) => DataRowModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataRowModel.fromJson(Map<String, dynamic> json) => DataRowModel(
    idIndicateur: json["id_indicateur"],
    numero: json["numero"],
    value: json["value"],
    estValide: json["est_valide"],
    colonne: json["colonne"],
  );

  Map<String, dynamic> toJson() => {
    "id_indicateur": idIndicateur,
    "numero": numero,
    "colonne": colonne,
    "value": value,
    "est_valide": estValide,
  };
}

