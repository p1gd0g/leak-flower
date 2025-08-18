import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/connect.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:myapp/route/account.dart';
import 'package:myapp/util/screen.dart';
import 'package:myapp/view/movie.dart';
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
  Get.put(ConnectController());

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
    final pbc = Get.put(PBController());
    return Scaffold(
      appBar: AppBar(title: const Text("韭花")),
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
                          final outputCard = snapshot.data?.body;
                          if (outputCard == null) {
                            return Text('No data found');
                          }
                          return MovieItem(outputCard, movieRecord);
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
