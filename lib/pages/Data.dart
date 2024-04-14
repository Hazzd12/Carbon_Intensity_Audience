import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../util/customizedUtil.dart';

double preVal =80;
double actVal = 20;
class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  // Dummy data for the pie chart
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sketch Page'),
      ),
      body: Stack(
          //fit: StackFit.expand, // 使Stack填满整个屏幕
          children: <Widget>[
            // 背景图片
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/background.jpg'), // 替换为你的背景图路径
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                DatePickerFormField(
                  label: 'From',
                  selectedDate: fromDate,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      fromDate = value;
                    });
                  },
                ),
                DatePickerFormField(
                  label: 'To',
                  selectedDate: toDate,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      toDate = value;
                    });
                  },
                ),
                getChart(),
                ElevatedButton(
                  onPressed: () {
                    // Insert search logic here
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ]),
    );
  }
}

  Widget getChart(){
   return SfRadialGauge(
     axes: <RadialAxis>[
       // 左半边的径向量表
       RadialAxis(
         minimum: 0,
         maximum: 100,
         showLabels: false,
         showTicks: false,
         centerX: 0.49,
         centerY: 0.5,
         startAngle:91,
         endAngle: 269,
         radiusFactor: 0.75,  // 调整大小
         //canScaleToFit: true,
         axisLineStyle: AxisLineStyle(
           thickness: 0.1,
           thicknessUnit: GaugeSizeUnit.factor,
           color: const Color(0xFFB6BAA7),
         ),
         pointers: <GaugePointer>[
           NeedlePointer(
             value: 50,  // 这个值应该根据需要设置
             needleStartWidth: 1,
             needleEndWidth: 4,
             needleColor: Colors.black,
             lengthUnit: GaugeSizeUnit.factor,
             needleLength: 0.5,
           ),
         ],
       ),
       // 右半边的径向量表
       RadialAxis(
         minimum: 00,
         maximum: 100,
         showLabels: false,
         showTicks: false,
        centerX: 0.51,
         startAngle: -90,
         endAngle: 90,
         radiusFactor: 0.75,  // 调整大小
         //canScaleToFit: true,
         axisLineStyle: AxisLineStyle(
           thickness: 0.1,
           thicknessUnit: GaugeSizeUnit.factor,
           color: const Color(0xFFB6BAA7),
         ),
         pointers: <GaugePointer>[
           NeedlePointer(
             value: 50,  // 这个值应该根据需要设置
             needleStartWidth: 1,
             needleEndWidth: 4,
             needleColor: Colors.black,
             lengthUnit: GaugeSizeUnit.factor,
             needleLength: 0.5,
           ),
         ],
         isInversed: true,  // 逆时针旋转
       ),
     ],
   );
  }