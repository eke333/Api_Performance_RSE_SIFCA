import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../models/pilotage/indicateur_model.dart';
import '../../../../controllers/drop_down_controller.dart';
import '../../../../controllers/tableau_controller.dart';
import 'row_indicateur.dart';

class RowEnjeu extends StatefulWidget {
  final String numero;
  final String idPilier;
  final String idEnjeu;
  final String enjeuTitle;
  final Color color;
  final List<IndicateurModel> indicateurs;
  const RowEnjeu(
      {Key? key,
        required this.enjeuTitle,
        required this.idEnjeu,
        required this.idPilier,
        required this.color,
        required this.numero, required this.indicateurs})
      : super(key: key);

  @override
  State<RowEnjeu> createState() => _RowEnjeuState();
}

class _RowEnjeuState extends State<RowEnjeu> {


  bool estVisibleIndicateur = false;
  final TableauBordController tableauBordController  = Get.find();
  final DropDownController dropDownController = Get.find();

  @override
  Widget build(BuildContext context) {
    final indicateurs = widget.indicateurs.where((indicateur) => indicateur.enjeu == widget.idEnjeu);
    return Obx(() {
      bool isFiltreEnjeu = dropDownController.filtreViewAxe["enjeu"]??false;
      bool debloqueFunEnjeu = isFiltreEnjeu ? dropDownController.filtreViewAxe[widget.idEnjeu]?? false : true;
      return Column(
        children: [
          Visibility(
            visible: true,
            child: Container(
              height: 30,
              padding: const EdgeInsets.only(left: 100),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.7),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${widget.numero}. ${widget.enjeuTitle}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Container()),
                  RotatedBox(
                    quarterTurns: estVisibleIndicateur ? 1 : 3,
                    child: IconButton(
                      splashRadius: 10,
                      icon: const Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 15,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (debloqueFunEnjeu) {
                          setState(() {
                            estVisibleIndicateur = !estVisibleIndicateur;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ),
          Visibility(
              visible: estVisibleIndicateur,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: indicateurs.map((indicateur){
                    return RowIndicateur(indicateur: indicateur);
                  }).toList()
              )
          ),
        ],
      );
    });
  }

  List<dynamic> getValeurs(int numeroLigne) {
    try {
      final datasRow = tableauBordController.dataIndicateur.value;
      final List<dynamic> dataLigne = datasRow.valeurs[numeroLigne];
      return dataLigne;
    } catch (e) {
      return [];
    }

  }

  List<dynamic> getValidation(int numeroLigne) {
    try {
      final datasRow = tableauBordController.dataIndicateur.value;
      final List<dynamic> validationLigne = datasRow.validations[numeroLigne];
      return validationLigne;
    } catch (e) {
      return [];
    }
  }

}