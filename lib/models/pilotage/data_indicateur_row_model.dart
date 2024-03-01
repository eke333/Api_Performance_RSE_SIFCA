import 'dart:convert';

class DataIndicateurRowModel {
  final String entite;
  final int annee;
  final List<dynamic> valeurs;
  final List<dynamic> validations;
  late final List<dynamic> ecarts;
  late final List<dynamic> cibles; //ajout

  DataIndicateurRowModel({
    required this.entite,
    required this.annee,
    required this.valeurs,
    required this.validations,
    required this.ecarts,
    required this.cibles,
  });

  factory DataIndicateurRowModel.fromRawJson(String str) =>
      DataIndicateurRowModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataIndicateurRowModel.init() => DataIndicateurRowModel(
      entite: "", annee: 0, valeurs: [], validations: [], ecarts: [], cibles: []);

  factory DataIndicateurRowModel.fromJson(Map<String, dynamic> json) =>
      DataIndicateurRowModel(
        entite: json["entite"],
        annee: json["annee"],
        valeurs: json["valeurs"],
        validations: json["validations"],
        ecarts: json["ecarts"],
        cibles: json["cibles"]
      );

  Map<String, dynamic> toJson() => {
        "entite": entite,
        "annee": annee,
        "valeurs": valeurs,
        "validations": validations,
        "ecarts": ecarts,
        "cibles": cibles,
      };
}
