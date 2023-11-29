import 'package:flutter/material.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../widgets/custom_text.dart';
import 'chart_overview.dart';
import 'data_info_card.dart';

class SuiviDetails extends StatefulWidget {
  const SuiviDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<SuiviDetails> createState() => _SuiviDetailsState();
}

class _SuiviDetailsState extends State<SuiviDetails> {
  double isHovering = 3;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text:"Suivi des données 2023",
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10),
              ChartOverview(),
              DataInfoCard(
                svgSrc: "assets/icons/data_validated.png",
                title: "Données Validées",
                amountOfFiles: "450",
                numOfFiles: 1328,
                color: Colors.green,
              ),
              DataInfoCard(
                svgSrc: "assets/icons/data_collect.png",
                title: "Données Collectées",
                amountOfFiles: "450",
                numOfFiles: 1328,
                color: Colors.amber,
              ),
              DataInfoCard(
                svgSrc: "assets/icons/no_data.png",
                title: "Champs vides",
                amountOfFiles: "450",
                numOfFiles: 1328,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
