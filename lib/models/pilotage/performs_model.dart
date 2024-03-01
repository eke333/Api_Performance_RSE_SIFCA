class EntityPerfomsModel {
  late final String entite;
  late final int annee;
  final List<dynamic> performsPiliers;
  final List<dynamic> performsEnjeux;

  EntityPerfomsModel({
    required this.entite,
    required this.annee,
    required this.performsPiliers,
    required this.performsEnjeux,
  });

  factory EntityPerfomsModel.init() => EntityPerfomsModel(
      entite: "", annee: 0, performsPiliers: [], performsEnjeux: []);
}
