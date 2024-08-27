import 'package:baseproject/pages/chart_type.dart';
import 'package:baseproject/widgets/radialChart/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TranscationBarChart extends StatefulWidget {
  final String title;
  final dynamic weeklytransactionData;
  final dynamic monthlyTransactionData;
  final dynamic yearlyTransactionData;

  ChartType chatytype;

  TranscationBarChart(
      {super.key,
      required this.chatytype,
      required this.weeklytransactionData,
      required this.monthlyTransactionData,
      required this.yearlyTransactionData,
      required this.title});

  @override
  State<TranscationBarChart> createState() => _TranscationBarChartState();
}

class _TranscationBarChartState extends State<TranscationBarChart> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: height * 0.25,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(border: Border.all(width: 0)),
                groupsSpace: 15,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        // print(value);
                        TextStyle style = const TextStyle(
                          color: lightTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        switch (widget.chatytype) {
                          case ChartType.Day:
                            // Assuming value corresponds to the index in dashboarddata
                            int index = value.toInt();
                            if (index >= 0 &&
                                index < widget.weeklytransactionData.length) {
                              return Text(
                                  widget.weeklytransactionData[index]["name"],
                                  style: style);
                            } else {
                              return Text('', style: style);
                            }
                          case ChartType.Month:
                            // Assuming value corresponds to the index in dashboarddata
                            int index = value.toInt();
                            if (index >= 0 &&
                                index < widget.monthlyTransactionData.length) {
                              return Text(
                                  widget.monthlyTransactionData[index]["month"],
                                  style: style);
                            } else {
                              return Text('', style: style);
                            }
                          case ChartType.Year:
                            // Assuming value corresponds to the index in dashboarddata
                            int index = value.toInt();
                            if (index >= 0 &&
                                index < widget.yearlyTransactionData.length) {
                              return Text(
                                  widget.yearlyTransactionData[index]["year"],
                                  style: style);
                            } else {
                              return Text('', style: style);
                            }
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, hh) {
                        TextStyle style = TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: value > 999 ? 8 : 10,
                        );
                        return Text(
                          value > 999
                              ? "${(value / 1000).toStringAsFixed(1)} k"
                              : value.toStringAsFixed(0),
                          style: style,
                        );
                        // switch (value.toInt()) {
                        //   case 1:
                        //     return Text('1K', style: style);
                        //   case 2:
                        //     return Text('2K', style: style);
                        //   case 3:
                        //     return Text('3K', style: style);
                        //   case 7:
                        //     return Text('7K', style: style);
                        //   case 100:
                        //     return Text('7K', style: style);
                        //   default:
                        //     return Text('', style: style);
                        // }
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: getBarChartGroupData(),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.chatytype = ChartType.Day;
                  });
                },
                child: Text(
                  "Weekly",
                  style: TextStyle(
                      color: widget.chatytype == ChartType.Day
                          ? Colors.blue
                          : Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.chatytype = ChartType.Month;
                  });
                },
                child: Text(
                  "Monthly",
                  style: TextStyle(
                      color: widget.chatytype == ChartType.Month
                          ? Colors.blue
                          : Colors.grey),
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.chatytype = ChartType.Year;
                    });
                  },
                  child: Text(
                    "Yearly",
                    style: TextStyle(
                        color: widget.chatytype == ChartType.Year
                            ? Colors.blue
                            : Colors.grey),
                  )),
            ],
          )
        ],
      ),
    );
  }

  List<BarChartGroupData>? getBarChartGroupData() {
    switch (widget.chatytype) {
      case ChartType.Day:
        final List<BarChartGroupData> barGroups = widget.weeklytransactionData
            .asMap()
            .entries
            .map<BarChartGroupData>((entry) {
          int index = entry.key;
          int count = entry.value['purchaseSuccessCount'];

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                width: 5,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }).toList();
        return barGroups;

      case ChartType.Month:
        final List<BarChartGroupData> barGroups = widget.monthlyTransactionData
            .asMap()
            .entries
            .map<BarChartGroupData>((entry) {
          int index = entry.key;
          int count = entry.value['count'];

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                width: 5,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }).toList();
        return barGroups;
      case ChartType.Year:
        final List<BarChartGroupData> barGroups = widget.yearlyTransactionData
            .asMap()
            .entries
            .map<BarChartGroupData>((entry) {
          int index = entry.key;
          int count = entry.value['count'];

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                width: 5,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }).toList();
        return barGroups;
    }
  }
}
