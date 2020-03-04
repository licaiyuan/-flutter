import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';
import 'package:cookie_jar/cookie_jar.dart';

const serviceUrl = 'http://183.252.1.140:81/api/';
//  BaseOptions options;
var options = new BaseOptions(
  //Http请求头.
  headers: {
    //do something
    'Cookie': 'JSESSIONID=797c373c-0885-4f50-b994-0d779e4f6f73'
  },
);
Dio dio = new Dio();
var cookieJar = CookieJar();
// dio.interceptors.add(CookieManager(cookieJar));

Response response;

//登錄
Future dl(value) async {
  try {
    response = await dio.post(servicePath['login'], data: value);
    return response;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获取列表
Future getList(value) async {
  print(value);

  try {
    response = await dio.get(servicePath['getList'], queryParameters: value);
    return response;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//工单处理
Future dealwith(value) async {
  print(servicePath['dealwith']);
  try {
    response = await dio.post(servicePath['dealwith'], data: value);
    return response;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//get通用请求

Future get(value, url) async {
  print(serviceUrl + url);
  // print(value);
  // try {
  //   response = await dio.get(serviceUrl + url, queryParameters: value);
  //   return response;
  // } catch (e) {
  //   return print('ERROR:======>${e}');
  // }
  response = await dio.get(serviceUrl + url, queryParameters: value);
  return response;
}

//post通用请求

Future post(value, url) async {
  print(serviceUrl + url);
  // print(value);
  response = await dio.post(serviceUrl + url, data: value);
  return response;
  // try {
  //   response = await dio.post(serviceUrl + url, data: value);
  //   return response;
  // } catch (e) {
  //   return print('ERROR:======>${e}');
  // }
}
