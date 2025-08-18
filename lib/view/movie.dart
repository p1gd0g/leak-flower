import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/connect.dart';
import 'package:myapp/view/rating.dart';

class MovieItem extends StatelessWidget {
  const MovieItem(this.outputCard, this.movieRecord, {super.key});

  final OutputCard outputCard;
  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: outputCard.imgUrl!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          outputCard.rating != null
              ? TextButton(
                  onPressed: () {
                    if (outputCard.rating != null) {
                      Get.to(() => RatingView(movieRecord));
                    }
                  },
                  child: Text('我要评分'),
                )
              : Text('我的评分：${outputCard.rating?.userRatingScore}'),
        ],
      ),
    );
  }
}
