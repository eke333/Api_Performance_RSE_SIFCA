import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../widgets/export_widget.dart';

class HeaderMainPage extends StatefulWidget {
  final String title;
  final Map mainPageData;
  const HeaderMainPage({Key? key, required this.title, required this.mainPageData}) : super(key: key);

  @override
  State<HeaderMainPage> createState() => _HeaderMainPageState();
}

class _HeaderMainPageState extends State<HeaderMainPage> {

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
      final nom = widget.mainPageData["user"]["nom"];
      final prenom = widget.mainPageData["user"]["prenom"];
      final email = widget.mainPageData["user"]["email"];
      return Container(
        height: 60,
        color: const Color(0xFFAAA095),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Image.asset(
                  "assets/logos/logo_sifca_blanc.jpg",
                  height: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                CustomText(
                  text: "Accueil ${widget.title}",
                  color: Colors.black,
                  weight: FontWeight.bold,
                  size: 30,
                )
              ],
            ),
            Row(
              children: [
                Center(
                  child: CustomText(
                    text: "${prenom} ${nom}",
                    color: Colors.white,
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                QudsPopupButton(
                  items: getMenuItems(shortName: "${prenom![0]}${nom![0]}",name: "${prenom} ${nom}",email: email!),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFFFFF00),
                    child: Center(
                      child: CustomText(
                        text: "${prenom![0]}${nom![0]}",
                        color: const Color(0xFFF1C232),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                  child: const Text(
                    "A propos de Perf RSE",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () async {
                    const url = "https://huboutils.visionstrategie.com";
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                    else {
                      throw "Could not launch $url";
                    }
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            )
          ],
        ),
      );
  }

  List<QudsPopupMenuBase> getMenuItems({required String shortName,required String name,required String email,}) {
    return [
      QudsPopupMenuItem(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFFFF00),
            child: Center(
              child: CustomText(
                text: shortName,
                color: const Color(0xFFF1C232),
                weight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            "${name}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subTitle: Text('${email}'),
          onPressed: () {}),
      QudsPopupMenuDivider(),
      QudsPopupMenuWidget(
          builder: (c) => Container(
              padding: const EdgeInsets.all(10),
              width: 800,
              child: IntrinsicHeight(
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Voulez-vous quitter cette application ?'),
                            content: const SizedBox(width:200,child: Text('Cliquez sur Oui pour vous déconnecter.')),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: <Widget>[
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Non'),
                              ),
                              OutlinedButton(
                                onPressed: () async{
                                  await storage.write(key: 'logged', value: "");
                                  await storage.write(key: 'email', value: "");
                                  await storage.deleteAll();
                                  context.go('/account/login');
                                },
                                child: const Text('Oui'),
                              ),
                            ],
                          );
                        },);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: const StadiumBorder(),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const CustomText(
                        text: "Se déconnecter",
                        color: Colors.white,
                      ),
                    )),
              )))
    ];
  }
}
