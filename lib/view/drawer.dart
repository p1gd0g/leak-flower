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
          FutureBuilder(
            future: pbc.getMyRatingAccuracy(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Text('No data found');
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('准确率：${snapshot.data?.toStringAsPrecision(2)}%'),
              );
            },
          ),
        ],
      ),
    );
  }
}
