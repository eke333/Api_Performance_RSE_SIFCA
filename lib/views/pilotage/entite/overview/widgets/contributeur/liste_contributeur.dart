import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import '../../../../../../widgets/custom_text.dart';
import 'contributeur_model.dart';

class ListeContributeur extends StatefulWidget {
  const ListeContributeur({
    Key? key,
  }) : super(key: key);

  @override
  State<ListeContributeur> createState() => _ListeContributeurState();
}

class _ListeContributeurState extends State<ListeContributeur> {

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Vous n'avez pas accès à cet espace."),
                const SizedBox(height: 20,),
                Image.asset("assets/images/forbidden.png",width: 50,height: 50,)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape : RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Liste des contributeurs",
                  weight: FontWeight.bold,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    context.go("/pilotage/espace/sucrivoire-siege/admin",extra: "Contributeurs");
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter"),
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  columns: const [
                    DataColumn(
                      label: Text("Nom"),
                    ),
                    DataColumn(
                      label: Text("Filiale"),
                    ),
                    DataColumn(
                      label: Text("Entité"),
                    ),
                    DataColumn(
                      label: Text("Accès"),
                    ),
                  ],
                  rows: List.generate(
                    demoContributeurs.length, (index) => contributeursDataRow(demoContributeurs[index]),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  DataRow contributeursDataRow(ContributeurModel fileInfo) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Image.asset(
                fileInfo.photo_url!,
                height: 30,
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(fileInfo.name!),
              ),
            ],
          ),
        ),
        DataCell(Text(fileInfo.entite!)),
        DataCell(Text(fileInfo.entite!)),
        DataCell(Text(fileInfo.access!)),
      ],
    );
  }
}



