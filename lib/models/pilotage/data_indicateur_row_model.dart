import 'dart:convert';

class DataIndicateurRowModel {
  final String entite;
  final int annee;
  final List<dynamic> valeurs;
  final List<dynamic> validations;

  DataIndicateurRowModel({
    required this.entite,
    required this.annee,
    required this.valeurs,
    required this.validations,
  });

  factory DataIndicateurRowModel.fromRawJson(String str) => DataIndicateurRowModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataIndicateurRowModel.init() => DataIndicateurRowModel(entite: "", annee: 0,valeurs: [], validations: []);

  factory DataIndicateurRowModel.fromJson(Map<String, dynamic> json) => DataIndicateurRowModel(
    entite: json["entite"],
    annee: json["annee"],
    valeurs: json["valeurs"],
    validations: json["validations"],
  );

  Map<String, dynamic> toJson() => {
    "entite": entite,
    "annee": annee,
    "valeurs": valeurs,
    "validations": validations,
  };
}
