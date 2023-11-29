import 'package:flutter/material.dart';
import '../../widgets/copyright.dart';
import 'sections/app_bar_evaluation.dart';
import 'sections/menu_evaluation.dart';
import 'home/evaluation_home.dart';

class EvaluationScreen extends StatefulWidget {
  final Widget child;
  const EvaluationScreen({super.key, required this.child});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  bool _isLoaded = false;
  late ScrollController _scrollController;

  void loadScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    loadScreen();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(238, 239, 243,.4),
        child: Column(
          children: [
            const AppBarEvaluation(),
            Expanded(child: Row(
              children: [
                const MenuEvaluation(),
                Expanded(
                  child: widget.child,
                )
              ],
            )),
            const CopyRight(),
          ],
        ),
      ),
    );
  }
}
