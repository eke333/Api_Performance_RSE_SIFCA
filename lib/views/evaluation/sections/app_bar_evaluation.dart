import 'package:flutter/material.dart';

class AppBarEvaluation extends StatefulWidget {

  const AppBarEvaluation({Key? key}) : super(key: key);

  @override
  State<AppBarEvaluation> createState() => _AppBarEvaluationState();
}

class _AppBarEvaluationState extends State<AppBarEvaluation> {

  @override
  Widget build(BuildContext context) {
    const nom ="HOUESSOU";
    const prenom ="HUEHANOU FABRICE";
    const email ="projet.dd@visionstrategie.com";
    return Container(
      height: 50,
      color: const Color.fromRGBO(170, 160, 150,1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 17,
              ),
              Image.asset(
                "assets/logos/logo_sifca_blanc.jpg",
                height: 50,
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("Evaluation RSE",
                  style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  )
              )
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  const Center(
                    child: Text("${prenom} ${nom}",style:TextStyle(
                      fontSize: 18,fontWeight: FontWeight.bold,
                      color:Colors.white,
                    )),
                  ),
                  const SizedBox(width: 7,),
                  CircleAvatar(
                    backgroundColor: Colors.yellowAccent,
                    child: Center(
                      child: Text(
                          "${prenom[0]}${nom[0]}",style: const TextStyle(
                        color: Color(0xFFF1CD0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                  ),

                ],
              ),
              const SizedBox(width: 30,),
              TextButton(onPressed:(){

              }, child:Image.asset(
                "assets/icons/bell.png",
                height: 38,
                color: Colors.white,
              ),)
            ],
          )
        ],
      ),
    );
  }
}
