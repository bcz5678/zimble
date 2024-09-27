import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zimble/home/home.dart';


import 'package:untitled/core/utils/auth_utils.dart';

import 'package:untitled/core/widgets/nav_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/features/reader/presentation/pages/reader.dart';
import 'package:untitled/features/tag_finder/presentation/pages/tag_info.dart';
import 'package:untitled/features/tag_finder/presentation/pages/find_tags.dart';
import 'package:untitled/features/inventory/presentation/pages/inventory.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  double? scrolledUnderElevation;

  bool shadowColor = false;


  final List<Widget> _tabs = [
    HomePage(),
    InventoryPage(),
    ReaderPage(),
    FindTagsPage(),
    TagInfoPage(),
    InventoryPage(),
  ];

  int _currentIndex = 0;

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