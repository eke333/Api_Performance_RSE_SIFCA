import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:popover/popover.dart';
import '../../../../../api/supabse_db.dart';
import 'package:animated_icon/animated_icon.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../controllers/profil_pilotage_controller.dart';
import '../../../controllers/tableau_controller.dart';

class FiltreTableauBord extends StatefulWidget {
  const FiltreTableauBord({Key? key}) : super(key: key);

  @override
  State<FiltreTableauBord> createState() => _EntityWidgetWidgetState();
}

class _EntityWidgetWidgetState extends State<FiltreTableauBord> {
  final TableauBordController tableauBordController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();
  final DataBaseController mongoDBController = DataBaseController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20,),
          const YearFiltreWidget(),
          const SizedBox(width: 10,),
          const MonthFiltreWidget(),
          const SizedBox(width: 10,),
          const AxeFiltreWidget(),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimateIcon(
              key: UniqueKey(),
              onTap: () {
                tableauBordController.refreshData();
              },
              iconType: IconType.animatedOnTap,
              color: Colors.blue,
              animateIcon: AnimateIcons.refresh,),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                hoverColor: Colors.blue.withOpacity(0.2),
                onTap: (){
                },
                child: Container(
                  padding:  const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(20),),
                  child: const Row(
                    children: [
                      SizedBox(width: 5,),
                      Icon(Icons.download_sharp,color: Colors.black,),
                      SizedBox(width: 10,),
                      Text("Exporter"),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
              )
            ),
          Obx(() {
            final acces = getAcces(profilPilotageController.accesPilotageModel.value);
            return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0),
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                child: CustomText(
                  text: "${acces}",
                  size: 13,
                  color: Colors.green,
                ));
          }),
          const SizedBox(width: 10,)
        ],
      ),
    );
  }

  String getAcces(AccesPilotageModel acces) {
    if (acces.estBloque == true) {
      return "Bloqué";
    }
    if (acces.estAdmin == true) {
      return " Admin ";
    }
    if (acces.estValidateur == true) {
      return "Validateur";
    }
    if (acces.estEditeur == true) {
      return "Editeur";
    }
    return "";
  }

}

class YearFiltreWidget extends StatefulWidget {
  const YearFiltreWidget({super.key});

  @override
  State<YearFiltreWidget> createState() => _YearFiltreWidgetState();
}

class _YearFiltreWidgetState extends State<YearFiltreWidget> {
  static const availbleYearList = <String>[
    '2023',
    '2022',
    '2021',
  ];

  bool isCheckBox = false;

  List<PopupMenuItem<String>> _popUpMenuYearItems() {
    return availbleYearList.map(
      (String value) {
        return PopupMenuItem<String>(
            value: value,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Text(value),
                ],
              );
            }));
      },
    ).toList();
  }

  final TableauBordController tableauBordController = Get.find();

  String _btn3SelectedYear = "";

  void initialisation(){
    setState(() {
      _btn3SelectedYear = tableauBordController.currentYear.value.toString();
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Année: ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Text("${_btn3SelectedYear}", style: const TextStyle(fontSize: 15)),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  onSelected: (String newValue) {
                    setState(() {
                      _btn3SelectedYear = newValue;
                      tableauBordController.changeYear(int.parse(_btn3SelectedYear));
                    });
                  },
                  itemBuilder: (BuildContext context) => _popUpMenuYearItems(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MonthFiltreWidget extends StatefulWidget {
  const MonthFiltreWidget({super.key});

  @override
  State<MonthFiltreWidget> createState() => _MonthFiltreWidgetState();
}

class _MonthFiltreWidgetState extends State<MonthFiltreWidget> {

  final TableauBordController tableauBordController = Get.find();


  @override
  void initState() {
    super.initState();
  }


  List<PopupMenuItem<Map<String,dynamic>>> _popUpMenuMonthItems(List<Map<String,dynamic>> monthList) {

    return monthList.map((month) {
      return PopupMenuItem<Map<String,dynamic>>(
          value: month,
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Obx((){
                  var _currentMonth = tableauBordController.currentMonth.value;
                  return Checkbox(
                      value:  month["id"] == _currentMonth,
                      splashRadius: 15,
                      checkColor: Colors.blue,
                      side: MaterialStateBorderSide.resolveWith(
                            (states){
                          return BorderSide(width: 2.0, color: month["id"] == _currentMonth ? Colors.blue : Colors.grey);
                        },
                      ),
                      fillColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                      onChanged: null
                  );
                }),
                const SizedBox(width: 20,),
                CustomText(text: "${month["month"]}")
              ],
            );
          }
          ));}
      ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Mois:  ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Obx((){
                  var _currentMonth = tableauBordController.currentMonth.value;
                  var _showMonth  = tableauBordController.listMonth[_currentMonth-1];
                  return Text("${_showMonth}", style: const TextStyle(fontSize: 15));
                }),
                const SizedBox(
                  width: 5,
                ),
                Obx((){
                  var currentMonth = tableauBordController.currentMonth.value;
                  var currentYear = tableauBordController.currentYear.value;
                  List<Map<String,dynamic>> _monthList = [];
                  var datetime = DateTime.now();
                  if (currentYear > datetime.year) {
                    return Container();
                  }
                  if (currentYear == datetime.year){
                    for(var i=0;i<datetime.month;i++){
                      _monthList.add(
                        {
                          "id":i+1,
                           "month":tableauBordController.listMonth[i]
                        }
                      );
                    }
                    return PopupMenuButton<Map<String,dynamic>>(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      splashRadius: 15,
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.grey,
                      ),
                      onCanceled: (){
                        setState(() {
                        });
                      },
                      onSelected: (Map<String,dynamic> newValue) {
                        setState(() {
                          tableauBordController.changeMonth(newValue["id"]);
                        });
                      },
                      itemBuilder: (BuildContext context) => _popUpMenuMonthItems(_monthList),
                    );
                  } else if(currentYear < datetime.year) {
                    for(var i=0;i<12;i++){
                      _monthList.add(
                          {
                            "id":i+1,
                            "month":tableauBordController.listMonth[i]
                          }
                      );
                    }
                    return PopupMenuButton<Map<String,dynamic>>(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      splashRadius: 15,
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.grey,
                      ),
                      onCanceled: (){
                        setState(() {
                        });
                      },
                      onSelected: (Map<String,dynamic> newValue) {
                        setState(() {
                          tableauBordController.changeMonth(newValue["id"]);
                        });
                      },
                      itemBuilder: (BuildContext context) => _popUpMenuMonthItems(_monthList),
                    );
                  }
                  return Container();
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AxeFiltreWidget extends StatefulWidget {
  const AxeFiltreWidget({super.key});

  @override
  State<AxeFiltreWidget> createState() => _AxeFiltreWidgetState();
}

class _AxeFiltreWidgetState extends State<AxeFiltreWidget> {
  bool isCheckBox = false;

  final TableauBordController tableauBordController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E5E7))),
        child: Row(
          children: [
            const SizedBox(width: 50,child: Text("Filtre", style: TextStyle(fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,),),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: (){
                showPopover(
                  context: context,
                  bodyBuilder: (context) => popoverWidget(context),
                  onPop: () => print('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  width: 300,
                  height: 200,
                  arrowHeight: 15,
                  arrowWidth: 30,
                );
              },
              padding: EdgeInsets.zero,
              splashRadius: 15,
              icon: const Icon(Icons.filter_alt_off_rounded,color: Colors.grey)
            )
          ],
        ),
      ),
    );
  }

  Widget popoverWidget(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin:  EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             OutlinedButton(
                 style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
                 child: Text("Effacer")
             ),
             OutlinedButton(
                 style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
                 child: Text("Appliquer")
             ),
           ],
          )
        ],
      ),
    );
  }


}

class EnjeuFiltreWidget extends StatefulWidget {
  const EnjeuFiltreWidget({super.key});

  @override
  State<EnjeuFiltreWidget> createState() => _EnjeuFiltreWidgetState();
}

class _EnjeuFiltreWidgetState extends State<EnjeuFiltreWidget> {
  static const enjeuList = <String>[
    "Tous",
  "1a. Gouvernance DD et stratégie",
  "1b. Pilotage DD",
  "2. Éthique des affaires et achats responsables",
  "3. Intégration des attentes DD des clients et consommateurs",
  "4. Égalité de traitement",
  "5. Conditions de travail",
  "6. Amélioration du cadre de vie",
  "7. Inclusion sociale et développement des communautés",
  "8. Changement climatique et déforestation",
  "9. Gestion et traitement de l’eau",
  "10. Gestion des ressources et déchets",
  ];

  static const index = <String>[
    "Tous",
    "1a",
    "1b",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];

  bool isCheckBox = false;

  List<PopupMenuItem<String>> _popUpMenuEnjeuListItems() {
    return enjeuList.map(
          (String value) {
        return PopupMenuItem<String>(
            value: value,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Text(value,style: const TextStyle(fontSize: 13),),
                ],
              );
            }));
      },
    ).toList();
  }

  String _btn3SelectedVal = "Tous";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Enjeu: ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Text("${_btn3SelectedVal}", style: const TextStyle(fontSize: 18,color: Colors.amber),maxLines: 1,overflow: TextOverflow.ellipsis,),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  tooltip: "Enjeux prioritaires",
                  splashRadius: 15,
                  constraints: const BoxConstraints(
                      minWidth: 200,
                      maxHeight: 400,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  onSelected: (String newValue) {
                    setState(() {
                      _btn3SelectedVal =  index[enjeuList.indexOf(newValue)];
                    });
                  },
                  itemBuilder: (BuildContext context) => _popUpMenuEnjeuListItems(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}

class ProcessusFiltreWidget extends StatefulWidget {
  const ProcessusFiltreWidget({super.key});

  @override
  State<ProcessusFiltreWidget> createState() => _ProcessusFiltreWidgetState();
}

class _ProcessusFiltreWidgetState extends State<ProcessusFiltreWidget> {
  static const processusList = <String>[
    'Tous',
    'Achat',
    'RH',
    "DD"
  ];

  bool isCheckBox = false;

  List<PopupMenuItem<String>> _popUpMenuProcessusItems() {
    return processusList.map(
          (String value) {
        return PopupMenuItem<String>(
            value: value,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Checkbox(value: true, onChanged: (coche){}),
                  const SizedBox(width: 10,),
                  Text(value),
                ],
              );
            }));
      },
    ).toList();
  }

  String _btn3SelectedVal = "Tous";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Processus: ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Text("${_btn3SelectedVal}", style: const TextStyle(fontSize: 20,color: Colors.red)),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  onSelected: (String newValue) {
                    setState(() {
                      _btn3SelectedVal = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) => _popUpMenuProcessusItems()
                 ),
              ],
            ),
          )
        ],
      ),
    );
  }
}




