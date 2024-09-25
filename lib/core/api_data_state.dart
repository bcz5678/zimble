import 'package:dio/dio.dart';

abstract class APIDataState<T> {
  final T ? data;
  final DioException ? error;

  const APIDataState({this.data, this.error});
}

class APIDataSuccess<T> extends APIDataState<T> {
  const APIDataSuccess(T data) : super(data: data);
}

class APIDataFailed<T> extends APIDataState<T> {
  const APIDataFailed(DioException error) : super(error: error);
}