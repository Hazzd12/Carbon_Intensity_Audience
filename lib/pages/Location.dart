import 'dart:async';
import 'package:carbon_intensity_audience/util/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../util/DatePicker.dart';
import '../util/customizedUtil.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  DateTime fromDate = DateTime.now();
  String warning = "The Date of To should be after From";
  bool validDate = true;

  double forecast = 0.0;
  String shortname = 'NULL';

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

  final TextEditingController _controller =
      TextEditingController(text: 'outward postcode');
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
          title: Text('Region'),
        ),
        body: SingleChildScrollView(
            child: Stack(
                //fit: StackFit.expand, // 使Stack填满整个屏幕
                children: <Widget>[
              // 背景图片
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/background.jpg'), // 替换为你的背景图路径
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        mySpace(20),
                        DatePicker(
                          label: 'From',
                          selectedDate: fromDate,
                          startDate: DateTime(2000),
                          endDate: DateTime.now(),
                          onDateSelected: (DateTime value) {
                            setState(() {
                              fromDate = value;
                            });
                          },
                        ),
                        getPositon(),
                        mySpace(30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomizedText('Forecast',
                                        font_Weight: FontWeight.normal,
                                        font_color: Colors.black,
                                        font_size: 18),
                                    CustomizedText('Name',
                                        font_Weight: FontWeight.normal,
                                        font_color: Colors.black,
                                        font_size: 18),
                                  ],
                                ),
                                mySpace(10),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomizedText(forecast.toString(),
                                          font_color: Colors.black,
                                          font_size: 20),
                                      CustomizedText(shortname,
                                          font_color: Colors.black,
                                          font_size: 20),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                        getChart(),
                        //Chart

                        CustomizedText(validDate ? "" : warning,
                            font_size: 18, font_color: Colors.red),
                        ElevatedButton(
                          onPressed: () async {
                            print(_controller.text);
                            var result = await fetchIntensityRegion(
                                fromDate, _controller.text);
                            setState(() {
                              forecast = result.forecast;
                              shortname = result.shortName;
                              for (int i = 0; i < result.factors.length; i++) {
                                pieData[i].yData = result.factors[i];
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
                  ))
            ])));
  }

  Widget getPositon() {
    return Container(
        width: 320,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomizedText("Postcode:", font_color: Colors.black, font_size: 25),
          SizedBox(width: 5),
          Container(
              alignment: Alignment.center,
              height: 50,
              width: 190,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Change this to desired border color
                  width: 2, // Change this to desired border width
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 125,
                  child: TextFormField(
                    controller: _controller,
                    // 当用户开始输入时，清除之前的文本
                    onTap: () {
                      _controller.clear();
                    },
                  ),
                ),
              ]))
        ]));
  }

  Widget getChart() {
    return Container(
        height: 350,
        child: SfCircularChart(
          legend: Legend(
              height: '40%',
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
