import 'package:flutter/material.dart';
import '../../../common/main_page/widget/header_main_page.dart';

class AppBarPilotageHome extends StatefulWidget {
  final Map pilotageHomeData;
  final String title;
  const AppBarPilotageHome({Key? key, required this.title, required this.pilotageHomeData}) : super(key: key);

  @override
  State<AppBarPilotageHome> createState() => _AppBarPilotageHomeState();
}

class _AppBarPilotageHomeState extends State<AppBarPilotageHome> {
  @override
  Widget build(BuildContext context) {
    return HeaderMainPage(title: widget.title,mainPageData: widget.pilotageHomeData,);
  }
}


