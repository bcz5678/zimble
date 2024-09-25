import 'package:flutter/material.dart';

import 'package:zimble/home/home.dart';
import 'package:zimble/reader/reader.dart';
import 'package:zimble/tag_info/tag_info.dart';
import 'package:zimble/find_tags/find_tags.dart';
import 'package:zimble/inventory/inventory.dart';
import 'package:zimble/trigger_status/trigger_status.dart';
import 'package:zimble/core/widgets/logout_confirm_dialog.dart';


class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff185677), Color(0xffe91e63)],
                stops: [0, 0.75],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
          ),
        ),
        Flexible(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.plus_one_outlined),
                title: const Text('Reader'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Reader(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.tag_outlined),
                title: const Text('Tag Info'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TagInfo(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.search_outlined),
                title: const Text('Find Tags'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FindTags(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.inventory_outlined),
                title: const Text('Inventory'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Inventory(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.barcode_reader),
                title: const Text('Trigger Status'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TriggerStatus(),
                  ));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey.shade200,
                ),
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () =>  showDialog(
                    context: context,
                    builder: (context) {
                      return LogoutConfirmationDialog();
                    }
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
