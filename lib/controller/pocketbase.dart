import 'dart:async';
import 'package:get/get.dart';
import 'package:myapp/controller/prefs.dart';
import 'package:pocketbase/pocketbase.dart';

const String collectionUsers = 'users';
const String fieldOrders = 'orders';
const String fieldEmail = 'email';
const String fieldPBAuth = 'pb_auth';

class PBController extends GetxController {
  late PocketBase pb;

  AuthStore get authStore => pb.authStore;
  bool get isSignedIn => pb.authStore.isValid;

  var pc = Get.put(PrefsController());

  @override
  onInit() async {
    super.onInit();

    var init = await pc.asyncPrefs.getString(fieldPBAuth);
    final store = AsyncAuthStore(
      save: (String data) async => pc.asyncPrefs.setString(fieldPBAuth, data),
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
