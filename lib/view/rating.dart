import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/connect.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RatingView extends StatelessWidget {
  const RatingView(this.movieRecord, {super.key});

  final MovieRecord? movieRecord;

  @override
  Widget build(BuildContext context) {
    var v = 1.0.obs;
    return SimpleDialog(
      // title: Text('评分'),
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
