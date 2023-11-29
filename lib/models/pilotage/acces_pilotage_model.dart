import 'dart:convert';

class AccesPilotageModel {
  String? email;
  String? entite;
  String? nomEntite;
  String? processus;
  bool? estSpectateur;
  bool? estEditeur;
  bool? estValidateur;
  bool? estAdmin;
  bool? estBloque;
  int? niveauAdmin;
  List<dynamic>? restrictions;

  AccesPilotageModel({
    this.email,
    this.entite,
    this.nomEntite,
    this.processus,
    this.estSpectateur,
    this.estEditeur,
    this.estValidateur,
    this.estAdmin,
    this.estBloque,
    this.niveauAdmin,
    this.restrictions,
  });

  factory AccesPilotageModel.fromRawJson(String str) => AccesPilotageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccesPilotageModel.fromJson(Map<dynamic, dynamic> json) => AccesPilotageModel(
    email: json["email"],
    entite: json["entite"],
    nomEntite: json["nom_entite"],
    processus: json["processus"],
    estSpectateur: json["est_spectateur"],
    estEditeur: json["est_editeur"],
    estValidateur: json["est_validateur"],
    estAdmin: json["est_admin"],
    estBloque: json["est_bloque"],
    niveauAdmin: json["niveau_admin"],
    restrictions: List<dynamic>.from(json["restrictions"].map((x) => x)
    ),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "entite": entite,
    "nom_entite": entite,
    "processus": processus,
    "est_spectateur": estSpectateur,
    "est_collecteur": estEditeur,
    "est_validateur": estValidateur,
    "est_admin": estAdmin,
    "est_bloque": estBloque,
    "niveau_admin": niveauAdmin,
    "restrictions": restrictions,
  };
}