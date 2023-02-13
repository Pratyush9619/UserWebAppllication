// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:assingment/style.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewPagesState();
}

class _OverviewPagesState extends State<Overview> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Site Survey', 35),
      ChartData('Detailed Engineering', 38),
      ChartData('Site Mobilization ', 34),
      ChartData('Approval Of Statutory', 52)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Text('Overview'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SfCircularChart(
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                  dataSource: chartData,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ],
          ),
          Image.asset(
            'assets/risk.png',
            width: 380,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
