import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdatedPage extends StatefulWidget {
  const UpdatedPage({super.key});

  @override
  State<UpdatedPage> createState() => _UpdatedPageState();
}

class _UpdatedPageState extends State<UpdatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 3,
                child: Container(
                  height: 600,
                  width: 1000,
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset("assets/images/new_verion_app.png",height: 300,fit: BoxFit.fill,)),
                      ),
                      const Text("Une nouvelle version de l'application est disponible.",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text("Pour accéder aux dernières améliorations de l'application, "
                            "nous vous invitons à rafraîchir la page en cliquant sur l'icône de mise à jour. "
                            "Cette mise à jour apporte des fonctionnalités et des performances améliorées, "
                            "garantissant une expérience utilisateur optimale.",style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      OutlinedButton(onPressed: (){
                        context.go("/");
                      }, child: const SizedBox(
                        width: 200,
                        height: 40,
                        child: Center(child: Text("Aller à l'accueil général")),
                      )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
