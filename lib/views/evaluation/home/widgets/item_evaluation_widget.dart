import 'package:flutter/material.dart';

class ItemEvaluationWidget extends StatefulWidget {
  final String dateCreation;
  final String dateDebut;
  final String dateFin;
  final String statut;
  final String dateValidation;
  final double? perfGlobale;
  const ItemEvaluationWidget(
      {super.key,
      required this.statut,
      required this.dateCreation,
      required this.dateDebut,
      required this.dateFin,
      this.perfGlobale,
      required this.dateValidation});

  @override
  State<ItemEvaluationWidget> createState() => _ItemEvaluationWidgetState();
}

class _ItemEvaluationWidgetState extends State<ItemEvaluationWidget> {
  @override
  Widget build(BuildContext context) {
    bool visible = true;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 2.0, right: 10),
        child: Container(
          height: 130,
          width: 600,
          child: Card(
            surfaceTintColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Identifiants: ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              children: [
                            TextSpan(
                                text: "N-${widget.dateCreation}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ])),
                      const SizedBox(
                        width: 30,
                      ),
                      widget.statut == "Evaluation validée"
                          ? RichText(
                              text: TextSpan(
                                  text: "Performance Globale: ",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  children: [
                                  TextSpan(
                                      text: "${widget.perfGlobale}%",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ]))
                          : const SizedBox(),
                      Expanded(child: Container()),
                      PopupMenuButton(
                          padding: const EdgeInsets.all(4.0),
                          surfaceTintColor: const Color.fromRGBO(238, 239, 243, 1),
                          icon: const RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.more_vert_outlined,
                                size: 25,
                              )),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  onTap: () {},
                                  child: TextButton.icon(
                                    onPressed: null,
                                    label: const Text(
                                      "Archiver",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    icon: const Icon(Icons.inbox_outlined),
                                  )),
                              PopupMenuItem(
                                onTap: () {},
                                child: TextButton.icon(
                                  onPressed: null,
                                  label: const Text(
                                    "Supprimer",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ];
                          }),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Periode:  ",
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                          children: [
                        TextSpan(
                            text: "${widget.dateDebut} au ${widget.dateDebut}",
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        const TextSpan(
                            text: "     Statut:    ",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        TextSpan(
                            text: widget.statut,
                            style: TextStyle(
                                color: widget.statut == "Evaluation terminée"
                                    ? Colors.green
                                    : widget.statut == "Evaluation validée"
                                        ? const Color.fromRGBO(52, 109, 182, 1)
                                        : widget.statut == "En cours"
                                            ? Colors.amber
                                            : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text: "     Date de validation:    ",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        TextSpan(
                            text: widget.dateValidation,
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                      ])),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.statut == "En cours"
                          ? TextButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/continuer.png",
                                width: 30,
                                height: 30,
                              ),
                              label: const Text("Continuer",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(52, 109, 182, 1))),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                      "assets/images/resultats.png",
                                      width: 30,
                                      height: 30),
                                  label: Text("Résultats",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: widget.statut ==
                                                  "Evaluation terminée"
                                              ? Colors.amber
                                              : widget.statut ==
                                                      "Evaluation validée"
                                                  ? Colors.green
                                                  : Colors.black)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset("assets/images/rapport.png",
                                      width: 30, height: 30),
                                  label: Text("Rapport",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: widget.statut ==
                                                  "Evaluation terminée"
                                              ? Colors.amber
                                              : widget.statut ==
                                                      "Evaluation validée"
                                                  ? Colors.green
                                                  : Colors.black)),
                                )
                              ],
                            ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Image.asset("assets/images/shield.png",
                                width: 30, height: 30),
                            label: const Text("Les droits d'accès",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          const Text("visibilité",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                          const SizedBox(
                            width: 20,
                          ),
                          Switch(
                              value: visible,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                setState(() {
                                  visible = value;
                                });
                              })
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
