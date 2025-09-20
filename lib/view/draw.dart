import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leak_flower/controller/pocketbase.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var pbc = Get.put(PBController());

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: SizedBox(),
            accountEmail: Text(pbc.getEmail() ?? ''),
          ),
        ],
      ),
    );
  }
}
