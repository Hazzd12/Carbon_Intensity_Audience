
import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

var uri = 'https://api.carbonintensity.org.uk/';

Future<List<double>> fetchIntensityData(DateTime fromDate, DateTime toDate) async {
  try {

    List dates = getDateString(fromDate, toDate);
    var url = Uri.parse(uri+'intensity/'+dates[0]+'T00:01Z/'+dates[1]+'T23:59Z');
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return(calculateAverages(data));
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return [0,0];
    // 处理发生的任何异常

  }
}


Future<myStatis> fetchIntensityStatistic(DateTime fromDate, DateTime toDate) async {
  try {

    List dates = getDateString(fromDate, toDate);
    var url = Uri.parse(uri+'intensity/stats/'+dates[0]+'T00:01Z/'+dates[1]+'T23:59Z');
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      var intensityData = data['data'][0]['intensity'];
      int max = intensityData['max'];
      int min = intensityData['min'];
      int avg = intensityData['average'];
      String index = intensityData['index'];

      return myStatis(max, avg, min, index);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e.toString());
    return myStatis(0, 0, 0, 'null');
    // 处理发生的任何异常
  }
}

Future<List<double>> fetchIntensityFactor(DateTime fromDate, DateTime toDate) async {
  try {

    List dates = getDateString(fromDate, toDate);
    var url = Uri.parse(uri+'generation/'+dates[0]+'T00:01Z/'+dates[1]+'T23:59Z');
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return(calculateFactors(data));
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e.toString());
    return [0,0];
    // 处理发生的任何异常

  }
}


List<String> getDateString(DateTime fromDate, DateTime toDate){
  final dateFormat = DateFormat('yyyy-MM-dd');
  return [dateFormat.format(fromDate), dateFormat.format(toDate)];
}

List<double> calculateAverages(Map<String, dynamic> data) {
  double forecastSum = 0;
  int forecastCount = 0;
  double actualSum = 0;
  int actualCount = 0;

  for (var entry in data['data']) {
    var intensity = entry['intensity'];
    forecastSum += intensity['forecast'];
    forecastCount++;
    if (intensity['actual'] != null) {
      actualSum += intensity['actual'];
      actualCount++;
    }
  }

  double forecastAvg = forecastSum / forecastCount;
  double actualAvg = actualCount > 0 ? actualSum / actualCount : 0;

  print('Average forecast: $forecastAvg');
  print('Average actual: $actualAvg');
  return [forecastAvg, actualAvg];
}

class myStatis{
  int max;
  int avg;
  int min;
  String index;

  myStatis(this.max,this.avg,this.min,this.index);

}

List<double> calculateFactors(Map<String, dynamic> data){

  Map<String, double> totals = {};

  Map<String, double> averages = {};

  // 初始化totals字典
  for (var entry in data['data']) {
    for (var mix in entry['generationmix']) {
      String fuel = mix['fuel'];
      double perc = mix['perc'].toDouble();
      totals[fuel] = (totals[fuel] ?? 0.0) + perc;
    }
  }

  // 计算每种燃料的平均值
  int count = data['data'].length;
  print(count);
  totals.forEach((fuel, total) {
    averages[fuel] = total / count;
  });

  // 打印每种燃料的平均百分比
  print('Average percentages for each fuel type:');
  averages.forEach((fuel, average) {
    print('$fuel: ${average.toStringAsFixed(2)}%');
  });
  return [0];
}