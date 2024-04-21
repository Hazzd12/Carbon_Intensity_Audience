import 'package:flutter/material.dart';
import '../util/customizedUtil.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度，以便所有按钮可以根据屏幕宽度设置一致的长度
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
              mySpace(150),
              Container(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Image.asset(
                    'asset/logo2.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              mySpace(50),
              Center(
                child: Column(
                  children: <Widget>[
                    myButton('Data',context,'/data', icon: Icons.dataset),
                    myButton('Statistic',context,'/statistic', icon: Icons.bar_chart),
                    myButton('Factor',context,'/factor', icon: Icons.pie_chart),
                    myButton('Location',context,'/location', icon: Icons.location_on),
                    // ... 其他按钮
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void goToData(BuildContext context){
  Navigator.pushNamed(context, '/data');
}
void test(){}