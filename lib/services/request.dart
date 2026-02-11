import 'package:dio/dio.dart';

const port = 3000;
const String host = '192.168.207.194';
const String url = 'http://$host:$port';

/*
final dio = Dio(BaseOptions(
    baseUrl: url,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));
*/

Future<Response> getMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  /*
  final response = await dio.get(url,
      queryParameters: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
  */
  // Mock response
  return Response(
    requestOptions: RequestOptions(path: url),
    statusCode: 200,
    data: {},
  );
}

Future<Response> postMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  /*
  final response =
      await dio.post(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
  */
  // Mock response
  return Response(
    requestOptions: RequestOptions(path: url),
    statusCode: 200,
    data: {},
  );
}

Future<Response> putMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  /*
  final response =
      await dio.get(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
  */
  // Mock response
  return Response(
    requestOptions: RequestOptions(path: url),
    statusCode: 200,
    data: {},
  );
}

Future<Response> deleteMethod(String url,
    [dynamic data, Map<String, dynamic>? headers]) async {
  url = '$url/$url';
  print('url: $url');

  /*
  final response =
      await dio.get(url, data: data, options: Options(headers: headers));
  print('response: ${response.data}');
  return response;
  */
  // Mock response
  return Response(
    requestOptions: RequestOptions(path: url),
    statusCode: 200,
    data: {},
  );
}
