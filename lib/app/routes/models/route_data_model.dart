import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RouteDataModel extends Equatable{
  RouteDataModel({
    required this.name,
    required this.path,
    this.title,
    this.icon,
    this.child,
  });

  final String name;
  final String path;
  late String? title;
  late IconData? icon;
  late Widget? child;

  @override
  List<Object?> get props {
    return [
      name,
      path,
      title,
      icon,
      child,
    ];
  }
}
