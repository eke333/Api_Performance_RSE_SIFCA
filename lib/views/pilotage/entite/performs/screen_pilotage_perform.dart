import 'package:flutter/material.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../widgets/privacy_widget.dart';
import 'perform_pilotage.dart';
import 'widgets/entete_performance.dart';


class ScreenPilotagePerform extends StatefulWidget {
  /// Constructs a [ScreenPilotagePerform] widget.
  const ScreenPilotagePerform({super.key});

  @override
  State<ScreenPilotagePerform> createState() => _ScreenPilotagePerformState();
}

class _ScreenPilotagePerformState extends State<ScreenPilotagePerform> {
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
    int width = MediaQuery.of(context).size.width.round();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Performances",style: TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            const SizedBox(height: 5,),
            const EntetePerformance(),
            const SizedBox(height: 5,),
            _isLoaded ? const Expanded(
              child: Column(
                children: [
                  Expanded(child: PerformPilotage()),
                  SizedBox(height: 10,),
                  PrivacyWidget(),
                  SizedBox(height: 20,),
                ],
              ),
            ) : Expanded(
              child: Column(
                children: [
                  Expanded(child: Center(
                    child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
                  )),
                  const SizedBox(height: 10,),
                  const PrivacyWidget(),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}