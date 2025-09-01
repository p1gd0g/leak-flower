import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/connect.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:leak_flower/route/account.dart';
import 'package:leak_flower/view/rating.dart';

Widget newPoster(OutputCard outputCard) {
  return ClipRect(
    child: AspectRatio(
      aspectRatio: 0.72, // 或你想要的比例
      child: CachedNetworkImage(
        imageUrl: outputCard.imgUrl!,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ),
  );
}
