import 'package:get/get.dart';
import 'package:myapp/controller/globalkey.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:myapp/view/login.dart';

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
