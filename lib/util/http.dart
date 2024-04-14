import 'package:http/http.dart' as http;

var uri = 'https://api.carbonintensity.org.uk/';
Future<void> fetchIntensityData() async {
  try {
    var url = Uri.parse(uri+'intensity');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // 如果服务器返回了200 OK响应，那么我们解析JSON数据
      print('Response body: ${response.body}');
    } else {
      // 如果响应不是200 OK，抛出异常
      throw Exception('Failed to load data');
    }
  } catch (e) {
    // 处理发生的任何异常
    print('Caught error: $e');
  }
}
