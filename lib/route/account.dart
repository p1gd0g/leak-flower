import 'package:get/get.dart';
import 'package:leak_flower/controller/globalkey.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:leak_flower/view/login.dart';

class AccountRoute {
  static onClickAccountBtn() {
    final pbc = Get.put(PBController());

    // pbc.pb.collection(collectionMovies).getFullList().then((value) {
    //   Get.log('Movies count: ${value.length}');
    // });

    if (pbc.isSignedIn) {
      Get.put(GlobalKeyController()).scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    Get.to(() => LoginView());
  }
}
