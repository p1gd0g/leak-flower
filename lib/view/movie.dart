import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/connect.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/view/poster.dart';
import 'package:leak_flower/view/rating.dart';

class MovieItem extends StatelessWidget {
  const MovieItem(this.movieRecord, {super.key});

  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    var cc = Get.put(ConnectController());
    var outputCard = cc.outputCards[movieRecord.doubanID];
    return InkWell(
      onTap: () {
        Get.to(() => MovieInfoView(outputCard.value, movieRecord));
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: MovieInfoView.heroTag,
            child: newPoster(outputCard!.value),
          ),
        ),
      ),
    );
  }
}

class MovieInfoView extends StatelessWidget {
  static String heroTag = 'movie_info_view_hero_tag';

  const MovieInfoView(this.outputCard, this.movieRecord, {super.key});

  final OutputCard outputCard;
  final MovieRecord movieRecord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(outputCard.movieRecord?.title ?? '')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: heroTag, child: newPoster(outputCard)),
            UserRatingRow(outputCard, movieRecord),
            LeakFlowerRatingRow(movieRecord),
          ],
        ),
      ),
    );
  }
}
