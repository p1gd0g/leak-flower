import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/connect.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'dart:developer' as developer;
import 'package:leak_flower/route/account.dart';
import 'package:leak_flower/util/screen.dart';
import 'package:leak_flower/util/theme.dart';
import 'package:leak_flower/view/movie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Def {
  static const String version = "vsn";
}

class Env {
  // build version
  static const version = String.fromEnvironment(Def.version);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((x) {
    FirebaseAnalytics.instance.logAppOpen();
  });

  Get.put(PBController());
  Get.put(ConnectController());

  runApp(
    GetMaterialApp(
      logWriterCallback: (value, {isError = false}) {
        // void defaultLogWriterCallback(String value, {bool isError = false}) {
        if (isError || Get.isLogEnable) {
          developer.log(
            '[${DateTime.now()}] $value\n${Trace.current().terse.frames.getRange(1, 4).join('\n')}',
            name: 'GETX',
          );
        }
        // }
      },
      home: Home(),
      title: "韭花",
      theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      // themeMode: ThemeMode.system,
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.put(PBController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => launchUrlString('https://www.p1gd0g.cc'),
            icon: Icon(Icons.account_circle),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("韭花", style: Get.textTheme.titleLarge),
            SizedBox(width: 8),
            Text('电影点映评分', style: Get.textTheme.titleMedium),
            SizedBox(width: 8),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    style: Get.textTheme.titleSmall,
                    "${Env.version}/${snapshot.data?.version ?? 'Unknown version'}",
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: pbc.pb.collection(collectionMovies).getFullList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final movies = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait ? 2 : 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 540 / 960,
                ),
                itemBuilder: (context, index) {
                  final movie = movies.elementAtOrNull(index);
                  if (movie == null) {
                    return null;
                  }
                  var id = movie.data[fieldDoubanID];
                  if (id == null) {
                    return null;
                  }
                  var movieRecord = MovieRecord.fromJson(movie.data);
                  final cc = Get.put(ConnectController());
                  return Center(
                    child: FutureBuilder(
                      future: cc.getMovieData(movieRecord),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final outputCard = snapshot.data;
                          if (outputCard == null) {
                            return Text('No data found');
                          }
                          return MovieItem(movieRecord);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AccountRoute.onClickAccountBtn(),
        child: Icon(Icons.account_box),
      ),
    );
  }
}
