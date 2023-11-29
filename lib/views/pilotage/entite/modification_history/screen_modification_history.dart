import 'package:flutter/material.dart';

class ScreenModificationHistory extends StatefulWidget {
  const ScreenModificationHistory({super.key});

  @override
  State<ScreenModificationHistory> createState() => _ScreenModificationHistoryState();
}

class _ScreenModificationHistoryState extends State<ScreenModificationHistory> {

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sujetController;
  late final TextEditingController _requestController;

  @override
  void initState() {
    _sujetController = TextEditingController();
    _requestController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Form(
          key: _formKey,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Le journal d'activité",style: TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }

}
