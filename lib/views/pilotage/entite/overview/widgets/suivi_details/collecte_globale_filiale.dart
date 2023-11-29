import 'package:flutter/material.dart';

import '../../../../../../constants/constant_colors.dart';
import '../../../../../../constants/constant_double.dart';

class CollecteGlobale extends StatefulWidget {
  const CollecteGlobale({
    Key? key,
  }) : super(key: key);

  @override
  State<CollecteGlobale> createState() => _CollecteGlobaleState();
}

class _CollecteGlobaleState extends State<CollecteGlobale> {

  final entityInfos = [
    {
      "nom":"SUCRIVOIRE",
      "2022":65,
      "2023":78
    },
    {
      "nom":"Sucrivoire Siège",
      "2022":25,
      "2023":68
    },
    {
      "nom":"Sucrivoire Zuénoula",
      "2022":70,
      "2023":45
    },
    {
      "nom":"Sucrivoire Borotou-Koro",
      "2022":69,
      "2023":80
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(

        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
                columnSpacing: 12,
                horizontalMargin: 12,
                columns: const [
                  DataColumn(
                    label: Text("Filiale/Entités"),
                  ),
                  DataColumn(
                    label: Text("2022"),
                  ),
                  DataColumn(
                    label: Text("2023"),
                  ),
                ],
                rows: List.generate(
                  entityInfos.length,
                      (index) => dataRow(entityInfos[index]),
                )
            )
          ],
        ),
      ),
    );
  }

  DataRow dataRow(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text("${entityInfo["2022"]} %",style: TextStyle(fontWeight: FontWeight.bold,color: entityInfo["2022"] < 30 ?  Colors.red :
        entityInfo["2022"] < 60 ? Colors.yellow : entityInfo["2022"] < 75 ?
        Colors.green : Colors.blue),)),
        DataCell(Text("${entityInfo["2023"]} %",style: TextStyle(fontWeight: FontWeight.bold,color: entityInfo["2023"] < 30 ?  Colors.red :
        entityInfo["2023"] < 60 ? Colors.yellow : entityInfo["2023"] < 75 ?
        Colors.green : Colors.blue),))

      ],
    );
  }
}