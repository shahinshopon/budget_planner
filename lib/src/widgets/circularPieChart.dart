


import 'package:budget_planner/src/model/category.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CircularPieChart extends StatelessWidget {
  // List<CircularStackEntry> chartData;
  // final GlobalKey<AnimatedCircularChartState> _chartKey =
  //     new GlobalKey<AnimatedCircularChartState>();

  // CircularPieChart(List<Map> data) {
  //   List<CircularSegmentEntry> entryList = [];
   

  //   for (var i = 0; i < data.length; i++) {
  //     var map = data[i];
  //     Category cat = map['category'];
  //     entryList.add(new CircularSegmentEntry(
  //         double.parse(map['expend']), Color(int.parse(cat.color)),
  //         rankKey: cat.timestamp.toString()));
  //   }

  //   this.chartData = <CircularStackEntry>[
  //     CircularStackEntry(
  //       entryList,
  //       rankKey: "",
  //     ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
     DateTime now = DateTime.now();
     
    String tabMonth = DateFormat.yMMMd().format(now.toLocal());
    // return new AnimatedCircularChart(
    //   key: _chartKey,
    //   size: const Size(280.0, 280.0),
    //   initialChartData: chartData,
    //   chartType: CircularChartType.Radial,
    //   holeRadius: 80,
    //   holeLabel: tabMonth,
    // );
  }
}
