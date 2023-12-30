import 'package:flutter/material.dart';
import '../../../../helper/responsive.dart';
import '../overview/widgets/suivi_details/suivi_details.dart';
import 'widgets/axe_suivi/suivi_axe.dart';
import 'widgets/suivi_mensuel/suivi_mensuel.dart';

class MonitoringPilotage extends StatefulWidget {
  const MonitoringPilotage({Key? key}) : super(key: key);

  @override
  State<MonitoringPilotage> createState() => _MonitoringPilotageState();
}

class _MonitoringPilotageState extends State<MonitoringPilotage> {

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 8,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SuiviAxe(),
                      const SizedBox(
                        height: 10,
                      ),
                      const SuiviMensuel(),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(height: 10,width: 10,color: Colors.transparent,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!Responsive.isMobile(context))
            const Row(
              children: [
                SizedBox(width: 5),
                SizedBox(width: 300, child: SuiviDetails()),
              ],
            )
        ],
      ),
    );
  }
}

