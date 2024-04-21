import 'dart:async';
import 'package:carbon_intensity_audience/util/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../util/DatePicker.dart';
import '../util/customizedUtil.dart';

class FactorPage extends StatefulWidget {
  @override
  _FactorPageState createState() => _FactorPageState();
}

class _FactorPageState extends State<FactorPage> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String warning = "The Date of To should be after From";
  bool validDate = true;

  List<PieData> pieData = [
    PieData('biomass', 0, Color(0xFF16A085)),
    PieData('coal', 0, Color(0xFF34495E)),
    PieData('imports', 0, Color(0xFF9b59b6)),
    PieData('gas', 0, Color(0xFF7F8C8D)),
    PieData('nuclear', 0, Color(0xfff56c02)),
    PieData('other', 0, Color(0xffe30fd5)),
    PieData('hydro', 0, Color(0xFF5DADE2)),
    PieData('solar', 0, Color(0xFFF7DC6F)),
    PieData('wind', 0, Color(0xFFD5DBDB)),
  ];

  int index = 0;

  late TooltipBehavior _tooltipBehavior;
  late DataLabelSettings _dataLabel;

  // Dummy data for the pie chart
  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
        //enable: true,
        );

    _dataLabel = const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        connectorLineSettings:
            ConnectorLineSettings(type: ConnectorType.curve, length: '5%'),
        textStyle: TextStyle(fontSize: 15));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('National Data'),
      ),
      body: Stack(
          //fit: StackFit.expand, // 使Stack填满整个屏幕
          children: <Widget>[
            // 背景图片
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/background.jpg'), // 替换为你的背景图路径
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                mySpace(20),
                DatePicker(
                  label: 'From',
                  selectedDate: fromDate,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      if (checkIfDateValid(value, toDate)) {
                        fromDate = value;
                        validDate = true;
                      } else {
                        validDate = false;
                        Timer(Duration(seconds: 5), () {
                          validDate = true;
                        });
                      }
                    });
                  },
                ),
                DatePicker(
                  label: 'To',
                  selectedDate: toDate,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      if (checkIfDateValid(fromDate, value)) {
                        toDate = value;
                        validDate = true;
                      } else {
                        validDate = false;
                        Timer(Duration(seconds: 5), () {
                          setState(() {
                            validDate = true;
                          });
                        });
                      }
                    });
                  },
                ),
                mySpace(30),

                //Chart
                getChart(),
                CustomizedText(validDate ? "" : warning,
                    font_size: 18, font_color: Colors.red),
                ElevatedButton(
                  onPressed: () async {
                    List<double> result =
                        await fetchIntensityFactor(fromDate, toDate);
                    setState(() {
                      for (int i = 0; i < result.length; i++) {
                        pieData[i].yData = result[i];
                      }
                    });
                  },
                  child: Text('Search',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ],
            ),
          ]),
    );
  }

  Widget getChart() {
    return Container(
        height: 400,
        child: SfCircularChart(
          legend: Legend(
              position: LegendPosition.bottom,
              iconHeight: 15,
              textStyle: TextStyle(fontSize: 20),
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Container(
                child: Text(
                  '${pieData[index].xData}',
                  style: TextStyle(
                      //color: Color.fromRGBO(216, 225, 227, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            )
          ],
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries<PieData, String>>[
            // Renders pie chart
            DoughnutSeries<PieData, String>(
              dataSource: pieData,
              xValueMapper: (PieData data, _) => data.xData,
              yValueMapper: (PieData data, _) => data.yData,
              pointColorMapper: (PieData data, _) => data.text,
              explode: true,
              explodeIndex: index,
              enableTooltip: true,
              radius: '80%',
              dataLabelMapper: (PieData data, _) =>
                  '${data.yData.toStringAsFixed(2)}%',
              dataLabelSettings: _dataLabel,
              onPointTap: (ChartPointDetails details) {
                index = details.pointIndex!;
                setState(() {});
              },
            )
          ],
        ));
  }
}
