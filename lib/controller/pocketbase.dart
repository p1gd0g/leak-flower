import 'dart:async';
import 'package:get/get.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/controller/prefs.dart';
import 'package:leak_flower/util/math.dart';
import 'package:pocketbase/pocketbase.dart';

const String collectionUsers = 'users';
const String collectionMovies = 'movies';
const String collectionRatings = 'ratings';

const String fieldOrders = 'orders';
const String fieldEmail = 'email';
const String fieldDoubanID = 'doubanID';
const String fieldUser = 'user';
const String fieldMovieID = 'movieID';
const String fieldUserRatingScore = 'userRatingScore';
const String fieldOpenRatingScore = 'openRatingScore';

const String keyPBAuth = 'pb_auth';

class PBController extends GetxController {
  late PocketBase pb;

  AuthStore get authStore => pb.authStore;
  bool get isSignedIn => pb.authStore.isValid;

  var pc = Get.put(PrefsController());

  @override
  onInit() async {
    super.onInit();

    var init = await pc.asyncPrefs.getString(keyPBAuth);
    final store = AsyncAuthStore(
      save: (String data) async => pc.asyncPrefs.setString(keyPBAuth, data),
      initial: init,
    );

    pb = PocketBase('https://pb.p1gd0g.cc', authStore: store);
  }

  Future<RecordModel> register(
    String email,
    String password,
    String passwordConfirm,
  ) {
    return pb
        .collection(collectionUsers)
        .create(
          body: {
            'email': email,
            'password': password,
            'passwordConfirm': passwordConfirm,
          },
        );
  }

  Future<RecordAuth> login(String email, String password) {
    return pb.collection(collectionUsers).authWithPassword(email, password);
  }

  String? getEmail() {
    return pb.authStore.record?.data[fieldEmail];
  }

  Future<Rating?> getRating(MovieRecord movieRecord) async {
    // final pbc = Get.put(PBController());
    final movieID = movieRecord.id;
    final userID = authStore.record?.id;
    Rating? rating;
    try {
      final record = await pb
          .collection(collectionRatings)
          .getFirstListItem('$fieldMovieID="$movieID" && $fieldUser="$userID"');
      rating = Rating.fromJson(record.data);
    } on ClientException catch (e) {
      Get.log('No rating found for movie $movieID: $e');
      return null;
    }
    return rating;
  }

  Future<double?> getLeakFlowerRating(MovieRecord movieRecord) async {
    // final pbc = Get.put(PBController());
    final movieID = movieRecord.doubanID;
    try {
      final records = await pb
          .collection(collectionRatings)
          .getFullList(filter: '$fieldMovieID="${movieRecord.id}"');

      List<Rating> ratings = records
          .map((record) => Rating.fromJson(record.data))
          .where((rating) => rating.userRatingScore != null)
          .toList();

      // todo 改为权重分数，而不是原始分数
      return ratings.isNotEmpty
          ? ratings.map((r) => r.userRatingScore!).reduce((a, b) => a + b) /
                ratings.length
          : 0;
    } on ClientException catch (e) {
      Get.log('No rating found for movie $movieID: $e');
      return 0;
    }
  }

  Future<double?> getMyRatingAccuracy() async {
    try {
      // get all my ratings
      var ratings = await pb
          .collection(collectionRatings)
          .getFullList(
            filter: '$fieldUser="${authStore.record?.id}"',
            expand: fieldMovieID,
          );
      if (ratings.isEmpty) {
        return null;
      }
      var accuSum = 0.0;
      for (var i = 0; i < ratings.length; i++) {
        var rating = ratings[i];

        var ratingObj = Rating.fromJson(rating.data);

        var openScore = rating.getDoubleValue(
          'expand.$fieldMovieID.$fieldOpenRatingScore',
        );
        var myScore = ratingObj.userRatingScore!;

        var accu = calcAccuracy(myScore, openScore);
        if (accu == null) {
          continue;
        }
        accuSum += accu;
      }
      return accuSum / ratings.length;
    } catch (e) {
      Get.log('Error fetching my ratings: $e');
      return null;
    }
  }
}
