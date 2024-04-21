import 'dart:async';
import 'package:carbon_intensity_audience/util/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../util/DatePicker.dart';
import '../util/customizedUtil.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String warning = "The Date of To should be after From";
  bool validDate = true;

  int max = 0;
  int min = 0;
  int avg = 0;
  String index = "moderate";

  // Dummy data for the pie chart
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistic'),
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
                  endDate: DateTime.now(),
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
                  endDate: DateTime.now(),
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
                //Chart\
                getChart(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomizedText('measure',
                            font_Weight: FontWeight.normal,
                            font_color: Colors.black,
                            font_size: 15),
                        mySpace(10),
                        CustomizedText(index,
                            font_color: getIndexColor(index), font_size: 20),
                      ],
                    ),
                  ),
                ),
                CustomizedText(validDate ? "" : warning,
                    font_size: 18, font_color: Colors.red),
                ElevatedButton(
                  onPressed: () async {
                    var message =
                        await fetchIntensityStatistic(fromDate, toDate);
                    setState(() {
                      max = message.max;
                      min = message.min;
                      avg = message.avg;
                      index = message.index;
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
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHorizontalGauges('max', _buildBarPointerWithShader(max)),
              _buildHorizontalGauges('avg', _buildBarPointerWithShader(avg)),
              _buildHorizontalGauges('min', _buildBarPointerWithShader(min)),
            ]));
  }

  Widget _buildHorizontalGauges(String axisTrackName, Widget linearGauge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(axisTrackName),
        linearGauge,
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBarPointerWithShader(int val) {
    return SizedBox(
        height: 80,
        child: SfLinearGauge(
            animateAxis: true,
            maximum: 500,
            interval: 100,
            orientation: LinearGaugeOrientation.horizontal,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: val.toDouble(),
                offset: 5,
                shaderCallback: _createShaderCallback(val),
                position: LinearElementPosition.outside,
                edgeStyle: LinearEdgeStyle.bothCurve,
              )
            ]));
  }

  Shader Function(Rect) _createShaderCallback(int val) {
    Shader shaderCallback(Rect bounds) {
      List<double> stops;
      if (val <= 150) {
        stops = [1.0, 1.1, 1.1];
      } else if (val <= 300) {
        double greenStop = 75.0 / val;
        stops = [greenStop, 1.0, 1.1];
      } else {
        double greenStop = 75.0 / val;
        double yellowStop = 300.0 / val;

        stops = [greenStop, yellowStop, 1.0];
      }

      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const <Color>[Colors.green, Colors.yellow, Colors.red],
        stops: stops,
        tileMode: TileMode.clamp,
      ).createShader(bounds);
    }

    // Return the closure that will act as the shader callback.
    return shaderCallback;
  }

  Color getIndexColor(String index){
    Color color;
    switch(index){
      case 'high':
        color = Colors.yellow;
        break;
      case 'very high':
        color = Colors.red;
        break;
      case 'null':
        color = Colors.black;
      default:
        color = Colors.green;
        break;
    }
    return color;
  }
}
