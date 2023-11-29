import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../home/widgets/item_evaluation_widget.dart';

class ListEvaluationScreen extends StatefulWidget {
  const ListEvaluationScreen({super.key});

  @override
  State<ListEvaluationScreen> createState() => _ListEvaluationScreenState();
}

class _ListEvaluationScreenState extends State<ListEvaluationScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height - 100,
      width: width - 160,
      child: Padding(
        padding: const EdgeInsets.only(top:26.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/search.png",width: 30,height: 30,),
                const SizedBox(width: 5,),
                const Text("Evaluation RSE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Listes des Evaluation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(
                  width: 8,
                ),
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
                Expanded(child: Container()),
                MaterialButton(
                  onPressed:(){},color: Colors.yellowAccent,
                  child: const Text("Entamer une évaluation",
                    style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 18),),),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      height: 250,
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
                          radius:
                          Radius.circular(10), // default Radius.circular(8.0)
                          thickness: 10.0, // [ default 8.0 ]
                          color: Colors.black, // default ColorScheme Theme
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
                )),
          ],
        ),
      ),
    );
  }
}
