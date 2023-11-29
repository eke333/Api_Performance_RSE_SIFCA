import 'package:flutter/material.dart';

class Banniere extends StatelessWidget {
  const Banniere({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset("assets/images/bannieresifca.png",width: 1300,height: 250,fit: BoxFit.fill,));
  }
}