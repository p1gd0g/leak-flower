import 'dart:async';

import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';

class ConnectController extends GetConnect {
  Map<int, Rx<OutputCard>> outputCards = {};

  Future<Response<OutputCard?>> getMovieData(MovieRecord movieRecord) async {
    final movieID = movieRecord.doubanID;
    final pbc = Get.put(PBController());

    Rating? rating;
    try {
      final record = await pbc.pb
          .collection(collectionRatings)
          .getFirstListItem(
            // '$fieldDoubanID="$movieID" && $fieldUser="${pbc.authStore.record?.id}"',
            '$fieldMovieID="${movieRecord.id}" && $fieldUser="${pbc.authStore.record?.id}"',
          );
      // Get.log('Rating for movie $movieID: ${record.data}');
      rating = Rating.fromJson(record.data);
    } on ClientException catch (e) {
      Get.log('No rating found for movie $movieID: $e');
    }

    final url = 'https://api.eo.p1gd0g.cc';
    return await get<OutputCard?>(
      url,
      decoder: (data) {
        final doc = parse(data);
        // <div class="picture-wrapper" style="background-image: url(https://img1.doubanio.com/view/photo/m_ratio_poster/public/p2924250338.jpeg)">

        var ele = doc.getElementsByClassName('picture-wrapper').firstOrNull;
        if (ele == null) {
          return null;
        }

        // "background-image: url(https://img1.doubanio.com/view/photo/m_ratio_poster/public/p2924250338.jpeg)"
        var style = ele.attributes['style'];
        var urlstr = style?.split('url(').lastOrNull?.split(')').firstOrNull;
        if (urlstr == null) {
          return null;
        }

        urlstr = urlstr.replaceFirst('https://', 'https://md.p1gd0g.cc/');

        var outputCard = OutputCard(imgUrl: urlstr, rating: rating);
        outputCards[movieID!] = outputCard.obs;

        return outputCard;
      },
      query: {'id': movieID.toString()},
    );
  }
}

class OutputCard {
  String? imgUrl;
  Rating? rating;
  OutputCard({this.imgUrl, this.rating});
}

class Rating {
  String? id;
  String? user;
  String? movieID;
  double? userRatingScore;
  double? userRatingStar;

  Rating(
    MovieRecord movieRecord, {
    this.id,
    this.user,
    this.movieID,
    this.userRatingScore,
    this.userRatingStar,
  });

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json[fieldUser];
    movieID = json[fieldMovieID];
    userRatingScore = (json['userRatingScore'] as num?)?.toDouble();
    userRatingStar = (json['userRatingStar'] as num?)?.toDouble();
  }
}

class MovieRecord {
  String? id;
  int? doubanID;

  MovieRecord({this.id, this.doubanID});

  MovieRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doubanID = json[fieldDoubanID];
  }
}
