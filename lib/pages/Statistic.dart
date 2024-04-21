import 'dart:async';
import 'package:carbon_intensity_audience/util/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      if(checkIfDateValid(value, toDate)) {
                        fromDate = value;
                        validDate = true;
                      }
                      else{
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
                      if(checkIfDateValid(fromDate, value)) {
                        toDate = value;
                        validDate = true;
                      }
                      else{
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


                CustomizedText(validDate?"":warning,
                    font_size: 18,font_color: Colors.red),
                ElevatedButton(
                  onPressed: () async {

                    var a =await fetchIntensityStatistic(fromDate, toDate);
                    print(a.avg);
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

void getChart() {
  return ;
}

