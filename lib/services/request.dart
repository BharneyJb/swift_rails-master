import 'package:dio/dio.dart';

final port = 3000;
final String host = '192.168.207.194';
final String url = 'http://$host:$port';

final dio = Dio(BaseOptions(
    baseUrl: url,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
    sendTimeout: Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

Future<Response> getMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  final response = await dio.get(url,
      queryParameters: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
}

Future<Response> postMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  final response =
      await dio.post(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
}

Future<Response> putMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  final response =
      await dio.get(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
}

Future<Response> deleteMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  final response =
      await dio.get(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
}
