import 'package:dropdown_button2/dropdown_button2.dart';
import "package:flutter/material.dart";
import 'package:pie_chart/pie_chart.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import 'widgets/card_header_widget.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/item_evaluation_widget.dart';

class EvaluationHome extends StatefulWidget {
  const EvaluationHome({super.key});

  @override
  State<EvaluationHome> createState() => _EvaluationHomeState();
}

var dataMap = [
  {
    "titre": "Performance QSE",
    "statut": {
      "En cours": 50,
      "Terminée": 30,
      "Validée": 20,
    },
    "legendLabls": {
      "En cours": "En cours",
      "Terminée": "Terminée",
      "Validée": "Validée",
    },
    "listColor": [
      Colors.grey,
      Colors.green,
      const Color(0xff6c5ce7),
    ]
  },
  {
    "titre": "Performance Globale",
    "statut": {
      "Performance": 70,
      "Ecart à combler": 30,
    },
    "legendLabls": {
      "Performance": "Performance",
      "Ecart à combler": "Ecart à combler",
    },
    "listColor": [
      Colors.green,
      Colors.red,
    ]
  }
];
ScrollController _scrollController = ScrollController();
String? selectedValue;

class _EvaluationHomeState extends State<EvaluationHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20,right: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accueil
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                Text("Accueil",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ))
              ],
            ),
            // Apercu général des audits
            const Text(
              "Apercu général des audits",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF3C3D3F),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            //Statistiques des evaluations & Statistiques des evaluations
            Row(
              children: [

                Container(
                  width: 250,
                  height: 230,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Statistiques des evaluations",style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3C3D3F),
                      ),),
                      HeaderCardOverviewEvaluation(
                          title: "Nombre total d'évaluation:10",
                          dataMap: {
                            "En cours": 50,
                            "Terminée": 30,
                            "Validée": 20,
                          },
                          legendLabels: {
                            "En cours": "En cours",
                            "Terminée": "Terminée",
                            "Validée": "Validée",
                          },
                          listColorLegends: [
                            Colors.grey,
                            Colors.green,
                            Color(0xff6c5ce7),
                          ],
                          chartType: ChartType.disc,
                          legendPosition: LegendPosition.right,
                          typeChart: 'PieChart'),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(child: Container(
                  height: 230,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: CustomDropDown(
                              indication: 'Selectionner Audit',
                              items: const [
                                "Evaluation N-2023/10/18",
                                "Evaluation N-2023/10/19",
                                "Evaluation N-2023/10/20",
                                "Evaluation N-2023/10/21",
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            )),
                        //Text("   Apercu de l'audit N'AUDIT-20-05-2022",textAlign:TextAlign.start),
                      ),
                      const Row(
                        children: [
                          HeaderCardOverviewEvaluation(
                              title: "Performance Globale",
                              dataMap: {
                                "Performance": 70,
                                "Ecart à combler": 30,
                              },
                              legendLabels: {
                                "Performance": "Performance",
                                "Ecart à combler": "Ecart à combler",
                              },
                              listColorLegends: [
                                Colors.green,
                                Colors.red,
                              ],
                              chartType: ChartType.ring,
                              legendPosition: LegendPosition.bottom,
                              typeChart: 'PieChart'),
                          HeaderCardOverviewEvaluation(
                            title: "Performance par axe strategique",
                            typeChart: 'BarChart',
                          ),
                          HeaderCardOverviewEvaluation(
                            title: "Conclusion sur la conformte",
                            dataMap: {
                              "En cours": 50,
                              "Terminée": 30,
                              "Validée": 20,
                            },
                            legendLabels: {
                              "En cours": "En cours",
                              "Terminée": "Terminée",
                              "Validée": "Validée",
                            },
                            listColorLegends: [
                              Colors.grey,
                              Colors.green,
                              Color(0xff6c5ce7),
                            ],
                            chartType: ChartType.disc,
                            legendPosition: LegendPosition.right,
                            typeChart: 'PieChart',
                          )
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Listes des Evaluation",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.format_list_bulleted_rounded,
                              size: 25,
                            ),
                          ),
                          Expanded(child: Container()),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.filter_alt_outlined,
                              size: 20,
                              color: Colors.black,
                            ),
                            label: const Text("Filtre",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)),
                          ),
                          const SizedBox(
                            width: 18,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: VsScrollbar(
                            controller: _scrollController,
                            showTrackOnHover: true, // default false
                            isAlwaysShown: true, // default false
                            scrollbarFadeDuration: const Duration(
                                milliseconds:
                                500), // default : Duration(milliseconds: 300)
                            scrollbarTimeToFade: const Duration(
                                milliseconds:
                                800), // default : Duration(milliseconds: 600)
                            style: const VsScrollbarStyle(
                              hoverThickness: 10.0, // default 12.0
                              radius: Radius.circular(
                                  10), // default Radius.circular(8.0)
                              thickness: 10.0, // [ default 8.0 ]
                              color:
                              Colors.black, // default ColorScheme Theme
                            ),
                            child: ListView(
                              padding: const EdgeInsets.only(right: 12),
                              controller: _scrollController,
                              children: const [
                                ItemEvaluationWidget(
                                  statut: 'Evaluation terminée',
                                  perfGlobale: 35,
                                  dateCreation: '26-09-2023',
                                  dateDebut: '28-09-2023',
                                  dateFin: '05-10-2023',
                                  dateValidation: '10-10-2023',
                                ),
                                ItemEvaluationWidget(
                                  statut: 'Evaluation validée',
                                  perfGlobale: 35,
                                  dateCreation: '26-09-2023',
                                  dateDebut: '28-09-2023',
                                  dateFin: '05-10-2023',
                                  dateValidation: '10-10-2023',
                                ),
                                ItemEvaluationWidget(
                                  statut: 'En cours',
                                  perfGlobale: 35,
                                  dateCreation: '26-09-2023',
                                  dateDebut: '28-09-2023',
                                  dateFin: '05-10-2023',
                                  dateValidation: '10-10-2023',
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                    ]))
          ],
        ),
    );
  }
}
