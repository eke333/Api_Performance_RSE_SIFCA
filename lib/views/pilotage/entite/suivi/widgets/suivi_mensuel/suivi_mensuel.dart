import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SuiviMensuel extends StatefulWidget {
  const SuiviMensuel({super.key});

  @override
  State<SuiviMensuel> createState() => _SuiviMensuelState();
}

class _SuiviMensuelState extends State<SuiviMensuel> {
  double isHovering = 3;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 505,
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          child: const SuiviMensuelChart(),
        ),
      ),
    );
  }
}

class SuiviMensuelChart extends StatefulWidget {
  const SuiviMensuelChart({Key? key}) : super(key: key);

  @override
  State<SuiviMensuelChart> createState() => _SuiviMensuelChartState();
}

class _SuiviMensuelChartState extends State<SuiviMensuelChart> {

  late double _columnWidth;
  late double _columnSpacing;
  List<ChartSampleData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  bool _isLoaded = false ;
  bool isCardView = true ;


  void initialisation() async {
    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Jan.', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
      ChartSampleData(
          x: 'Fév.', y: 8, secondSeriesYValue: 10, thirdSeriesYValue: 7),
      ChartSampleData(
          x: 'Mars', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
      ChartSampleData(
          x: 'Avril', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'Mai', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'Juin', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
      ChartSampleData(
          x: 'Jui.', y: 8, secondSeriesYValue: 10, thirdSeriesYValue: 7),
      ChartSampleData(
          x: 'Août', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
      ChartSampleData(
          x: 'Sept.', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'Oct.', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'Nov.', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
      ChartSampleData(
          x: 'Déc.', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14)
    ];
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoaded = true;
    });
  }

  Image _getImage(int index) {
    final List<Image> images = <Image>[
      Image.asset('assets/icons/no_data.png'),
      Image.asset('assets/icons/data_collect.png'),
      Image.asset('assets/icons/data_validated.png'),
    ];
    return images[index];
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? _buildSpacingColumnChart() : const Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 4,
            )),
        SizedBox(
            height: 30,
            width: 30,
            child:
            CircularProgressIndicator(color: Colors.amber, strokeWidth: 4)),
      ],
    );
  }

  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Suivi des données mensuelles 2023 : Sucrivoire Siège',
          textStyle: const TextStyle(fontSize: 16,decoration: TextDecoration.underline)
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: "",textStyle: const TextStyle(fontSize: 14)),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: "Nombre d'occurrence"),
          maximum: 20,
          minimum: 0,
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(
      isVisible: true,
      position: LegendPosition.bottom,
      orientation: LegendItemOrientation.horizontal,
      overflowMode: LegendItemOverflowMode.wrap,
      toggleSeriesVisibility: false,
      legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
        return SizedBox(
           height: 40,
          width: index == 1 ? 95 : name.length.toDouble()*14,
          child: Row(
            children: [
              Container(height: 30, width: 30,child: _getImage(index),),
              const SizedBox(width: 10,height: 10,),
              Text(name),
              const SizedBox(width: 10,height: 10,),
            ],
          ),
        );
      },
    ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          dataSource: chartData!,
          color: Colors.red,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Champ vide'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: Colors.amber,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Saisie'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: Colors.green,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Validation'),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final double y;
  final double secondSeriesYValue;
  final double thirdSeriesYValue;
  ChartSampleData({
    required double this.thirdSeriesYValue,
    required String this.x,
    required double this.y,
    required double this.secondSeriesYValue,
  });
}

