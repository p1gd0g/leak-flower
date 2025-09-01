import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';

class OutputCard {
  String? imgUrl;
  Rating? rating;
  String? title;
  OutputCard({this.imgUrl, this.rating, this.title});
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
