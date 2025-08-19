import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/connect.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:leak_flower/route/account.dart';
import 'package:leak_flower/view/rating.dart';

class MovieItem extends StatelessWidget {
  const MovieItem(this.movieRecord, {super.key});

  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    var cc = Get.put(ConnectController());
    var outputCard = cc.outputCards[movieRecord.doubanID];
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: outputCard!.value.imgUrl!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Obx(() => Info(outputCard.value, movieRecord)),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info(this.outputCard, this.movieRecord, {super.key});

  final OutputCard outputCard;
  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    return outputCard.rating == null
        ? TextButton(
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
          )
        : Text('我的评分：${outputCard.rating?.userRatingScore}');
  }
}
