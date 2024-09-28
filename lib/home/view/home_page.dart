import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zimble/home/home.dart';


import 'package:zimble/core/utils/auth_utils.dart';

import 'package:zimble/core/widgets/nav_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:zimble/inventory/inventory.dart';
import 'package:zimble/readers/readers.dart';
import 'package:zimble/tag_finder/tag_finder.dart';
import 'package:zimble/tag_info/tag_info.dart';
import 'package:zimble/trigger/trigger.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? scrolledUnderElevation;

  bool shadowColor = false;

  final List<Widget> _tabs = [
    HomePage(),
    InventoryPage(),
    ReadersPage(),
    TagFinderPage(),
    TagInfoPage(),
    TriggerPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        scrolledUnderElevation: scrolledUnderElevation,
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () => {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .85,
        child: const NavDrawer(),
      ),

      body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
            ],
            ),
          )
      ),
    );
  }
}