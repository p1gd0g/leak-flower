import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/connect.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:leak_flower/route/account.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RatingView extends StatelessWidget {
  const RatingView(this.movieRecord, {super.key});

  final MovieRecord? movieRecord;

  @override
  Widget build(BuildContext context) {
    var v = 1.0.obs;
    return SimpleDialog(
      children: [
        Obx(
          () => SfSlider(
            onChanged: (value) {
              v.value = value as double;
            },
            value: v.value,
            min: 1.0,
            max: 10.0,
            interval: 0.1,
            stepSize: 0.1,
            enableTooltip: true,
            thumbIcon: Container(
              alignment: Alignment.center,
              child: Text(
                v.toString(),
                style: Get.textTheme.labelLarge?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Get.back(result: v.value);
                },
                child: const Text('我再想想'),
              ),
              TextButton(
                onPressed: () async {
                  Get.showOverlay(
                    loadingWidget: Center(
                      child: const CircularProgressIndicator(),
                    ),
                    asyncFunction: () async {
                      final pbc = Get.put(PBController());
                      try {
                        // todo 增加权重分
                        var ratingRecord = await pbc.pb
                            .collection(collectionRatings)
                            .create(
                              body: {
                                fieldUser: pbc.authStore.record?.id,
                                fieldMovieID: movieRecord?.id,
                                fieldUserRatingScore: v.value,
                              },
                            );
                        var cc = Get.put(ConnectController());
                        cc.outputCards[movieRecord!.doubanID!]!.value =
                            OutputCard(
                              imgUrl: cc
                                  .outputCards[movieRecord!.doubanID]
                                  ?.value
                                  .imgUrl,
                              rating: Rating.fromJson(ratingRecord.data),
                            );
                        Get.back();
                      } on ClientException catch (e) {
                        // if (e.statusCode == 400) {
                        //   return;
                        // }
                        Get.log('Error creating rating: $e');
                      }
                    },
                  );
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LeakFlowerRatingRow extends StatelessWidget {
  const LeakFlowerRatingRow(this.movieRecord, {super.key});

  final MovieRecord movieRecord;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.put(PBController()).getLeakFlowerRating(movieRecord),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data found');
        }

        return Text('韭花评分：${snapshot.data?.toStringAsFixed(1)}');
      },
    );
  }
}

class UserRatingRow extends StatelessWidget {
  const UserRatingRow(this.outputCard, this.movieRecord, {super.key});
  final OutputCard outputCard;
  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.put(PBController()).getRating(movieRecord),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData && outputCard.rating == null) {
          return TextButton(
            onPressed: () {
              final pbc = Get.put(PBController());
              if (pbc.isSignedIn) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RatingView(movieRecord);
                  },
                );
              } else {
                AccountRoute.onClickAccountBtn();
              }
            },
            child: Text('我要评分'),
          );
        } else {
          return Text(
            '我的评分：${snapshot.data?.userRatingScore?.toStringAsFixed(1)}',
          );
        }
      },
    );
  }
}
