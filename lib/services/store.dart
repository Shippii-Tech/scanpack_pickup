import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'error/error.dart';

class Store extends ChangeNotifier {
  bool _loading = false;
  TheError? error;
  bool get loading => _loading;
  set loading(bool newValue){
    if (newValue != _loading){
      _loading = newValue;
      notifyListeners();
    }
  }


  final dio = Dio(BaseOptions(
    baseUrl: 'https://scan-pickup-dev.vconnect.systems/api/v1',
    headers: {
      'Authorization': 'Bearer 1|BfOkmeIhWujSEqYP0OgDBdfOwzbDl4MFstyPYqeDa8619ae0',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  ));

  Store(){
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, _) async {
          if (e.response != null) {
            print(e.response?.data);
            print(e.response?.headers);
            print(e.response?.requestOptions);
          } else {
            print(e.requestOptions);
            print(e.message);
          }

          if (e.response != null) {
            error = TheError(message: e.response?.statusMessage ?? 'Something went wrong', status: e.response?.statusCode ?? 500);
          } else {
            error = TheError(message: e.message ?? 'Something went wrong', status: e.response?.statusCode ?? 500);
          }

          notifyListeners();
        },
      ),
    );
  }

  Future<Response<T>> fetch<T>(String url, {Map<String, dynamic>? params}) async {
    loading = true;

    try {
      return await dio.get(url, queryParameters: params);
    }
    finally {
      loading = false;
    }
  }

  Future<Response<T>> send<T>(String url, dynamic data) async {
    loading = true;

    try {
      return await dio.post(url, data: data);
    }
    finally {
      loading = false;
    }
  }
}

abstract mixin class RestAPI<T> {
  List<T> items = <T>[];
  bool loading = false;
  TheError? error;
  Future get(Map<String, dynamic>? payload);
}