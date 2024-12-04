import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:zimble/app/bloc/app_bloc.dart';
import 'mobile_router.dart';

class AppRouter {
  AppRouter({
    required AppBloc appBloc,
  }) : _appBloc = appBloc;

  final AppBloc _appBloc;

  /*
  GoRouter get router {

  }
  */
}