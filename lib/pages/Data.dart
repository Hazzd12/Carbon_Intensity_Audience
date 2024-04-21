import 'dart:async';

import 'package:carbon_intensity_audience/util/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../util/DatePicker.dart';
import '../util/customizedUtil.dart';

double preVal = 0;
double actVal = 0;

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String warning = "The Date of To should be after From";
  bool validDate = true;
  // Dummy data for the pie chart
  @override
  void initState() {
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
                  startDate: DateTime(2000),
                  endDate: DateTime(2100),
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
                  startDate: fromDate,
                  endDate: DateTime(2100),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomizedText("Forecast", font_color: Colors.grey),
                    SizedBox(width: 100),
                    CustomizedText("Actual", font_color: Colors.grey)
                  ],
                ),
                getChart(),
                CustomizedText(validDate ? "" : warning,
                    font_size: 18, font_color: Colors.red),
                ElevatedButton(
                  onPressed: () async {
                    // Insert search logic here
                    var list = await fetchIntensityData(fromDate, toDate);
                    setState(() {
                      preVal = list[0];
                      actVal = list[1];
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
}

Widget getChart() {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 00,
        maximum: 500,
        interval: 50,
        labelOffset: 0.1,
        tickOffset: 0.125,
        minorTicksPerInterval: 0,
        labelsPosition: ElementsPosition.outside,
        offsetUnit: GaugeSizeUnit.factor,
        showAxisLine: false,
        showLastLabel: true,
        startAngle: 90,
        endAngle: 270,
        radiusFactor: 0.75,
        //canScaleToFit: true,
        axisLineStyle: AxisLineStyle(
          thickness: 0.1,
          thicknessUnit: GaugeSizeUnit.factor,
          color: const Color(0xFFB6BAA7),
        ),
        pointers: <GaugePointer>[
          NeedlePointer(
              needleLength: 0.6,
              needleColor: const Color(0xFFF67280),
              needleStartWidth: 0,
              needleEndWidth: 5,
              enableAnimation: true,
              value: preVal,
              knobStyle: KnobStyle(
                  borderColor: const Color(0xFFF67280),
                  borderWidth: 0.015,
                  color: Colors.white,
                  knobRadius: 0.03))
        ],
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 150,
            color: const Color.fromRGBO(74, 177, 70, 1),
          ),
          GaugeRange(
            startValue: 150,
            endValue: 300,
            color: const Color.fromRGBO(251, 190, 32, 1),
          ),
          GaugeRange(
            startValue: 300,
            endValue: 500,
            color: const Color.fromRGBO(237, 34, 35, 1),
          )
        ],
      ),

      // 右半边的径向量表
      RadialAxis(
        minimum: 00,
        maximum: 500,
        interval: 50,
        labelOffset: 0.1,
        tickOffset: 0.125,
        minorTicksPerInterval: 0,
        labelsPosition: ElementsPosition.outside,
        offsetUnit: GaugeSizeUnit.factor,
        showAxisLine: false,
        showLastLabel: true,
        startAngle: -90,
        endAngle: 90,
        radiusFactor: 0.75, // 调整大小
        //canScaleToFit: true,
        axisLineStyle: AxisLineStyle(
          thickness: 0.15,
          thicknessUnit: GaugeSizeUnit.factor,
          color: const Color(0xFFB6BAA7),
        ),
        pointers: <GaugePointer>[
          NeedlePointer(
            value: actVal,
            needleLength: 0.6,
            needleColor: const Color(0xFFF67280),
            needleStartWidth: 0,
            needleEndWidth: 5,
            enableAnimation: true,
            knobStyle: KnobStyle(knobRadius: 0),
          ),
        ],
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 150,
            color: const Color.fromRGBO(74, 177, 70, 1),
          ),
          GaugeRange(
            startValue: 150,
            endValue: 300,
            color: const Color.fromRGBO(251, 190, 32, 1),
          ),
          GaugeRange(
            startValue: 300,
            endValue: 500,
            color: const Color.fromRGBO(237, 34, 35, 1),
          )
        ],
        isInversed: true, // 逆时针旋转
      ),
    ],
  );
}
