import 'package:flutter/material.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../widgets/privacy_widget.dart';
import 'monitoring_pilotage.dart';
import 'widgets/entete_suivi/entete_suivi.dart';

class ScreenPilotageSuivi extends StatefulWidget {
  /// Constructs a [ScreenPilotageSuivi] widget.
  const ScreenPilotageSuivi({super.key});

  @override
  State<ScreenPilotageSuivi> createState() => _ScreenPilotageSuiviState();
}

class _ScreenPilotageSuiviState extends State<ScreenPilotageSuivi> {
  bool _isLoaded = false;


  void loadScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Suivi des données",
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFF3C3D3F),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          const EnteteSuivi(),
          _isLoaded ? Expanded(child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData(
                  trackColor:  MaterialStateProperty.all(Colors.black12),
                  trackBorderColor: MaterialStateProperty.all(Colors.black38),
                  thumbColor: MaterialStateProperty.all(const Color(0xFF80868B)),
                  interactive: true,
                  )),
                  child: const MonitoringPilotage(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const PrivacyWidget(),
              const SizedBox(
                height: 20,
              ),
            ],
          ))  :
          Expanded(
            child: Column(
              children: [
                Expanded(child: Center(child: loadingPageWidget(),)),
                const SizedBox(
                  height: 10,
                ),
                const PrivacyWidget(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}



// Theme(

// child: Scrollbar(

// child: SingleChildScrollView(

// child: Padding(
// padding: EdgeInsets.only(right: 15),
// child: Expanded(child: Container(color: Colors.red,),)
// ),
// ),
// ),
// )
