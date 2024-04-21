import 'package:carbon_intensity_audience/pages/Data.dart';
import 'package:carbon_intensity_audience/pages/Factor.dart';
import 'package:carbon_intensity_audience/pages/Location.dart';
import 'package:carbon_intensity_audience/pages/Statistic.dart';
import 'package:carbon_intensity_audience/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the `routes` map
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // Check the name of the route
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => LandingPage());
            case '/home':
              return MaterialPageRoute(builder: (_)=> HomePage());
            case '/data':
              return MaterialPageRoute(builder: (_)=> DataPage());
            case '/statistic':
              return MaterialPageRoute(builder: (_)=> StatisticPage());
            case '/factor':
              return MaterialPageRoute(builder: (_)=> FactorPage());
            case '/location':
              return MaterialPageRoute(builder: (_)=> LocationPage());
          }
        });
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _animateImage();
  }

  void _animateImage() async {
    // Wait for 1 second
    await Future.delayed(Duration(seconds: 1));
    // Gradually show the image
    setState(() => _opacity = 1);
    // Keep the image visible for 2 seconds
    await Future.delayed(Duration(seconds: 2));
    // Gradually hide the image
    setState(() => _opacity = 0);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'asset/background.jpg',
            fit: BoxFit.cover,
          ),
          // Animated center image
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Image.asset('asset/logo.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}