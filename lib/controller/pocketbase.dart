import 'dart:async';
import 'package:get/get.dart';
import 'package:leak_flower/controller/prefs.dart';
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
    // Get.log('PocketBase initialized with auth store, ${pb.authStore.isValid}');
    // Get.log('PocketBase initialized with auth store, ${pb.authStore.record}');
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
}
