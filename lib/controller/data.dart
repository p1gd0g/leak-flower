import 'package:leak_flower/controller/pocketbase.dart';

class OutputCard {
  MovieRecord? movieRecord;
  Rating? myRating;
  OutputCard({this.myRating, this.movieRecord});

  String? get imgUrl {
    if (movieRecord == null || movieRecord!.picName == null) {
      return null;
    }
    return 'https://md.p1gd0g.cc/img3.doubanio.com/view/photo/s_ratio_poster/public/${movieRecord?.picName}.webp';
  }
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
  String? picName;
  String? title;
  int? doubanID;

  double? openRatingScore;

  MovieRecord({this.id, this.doubanID});

  MovieRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doubanID = json[fieldDoubanID];
    openRatingScore = (json['openRatingScore'] as num?)?.toDouble();
    picName = json['picName'];
    title = json['title'];
  }
}
