import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:myapp/route/account.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Def {
  static const String version = "vsn";
}

class Env {
  // build version
  static const version = String.fromEnvironment(Def.version);
}

void main() {
  Get.put(PBController());

  runApp(
    GetMaterialApp(
      home: Home(),
      title: "Leak FLower",
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("韭花")),
      body: Center(),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  "${Env.version}/${snapshot.data?.version ?? 'Unknown version'}",
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          IconButton(
            onPressed: () => AccountRoute.onClickAccountBtn(),
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}
