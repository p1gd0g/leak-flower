import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:myapp/controller/globalkey.dart';
import 'package:myapp/controller/pocketbase.dart';
import 'package:myapp/view/login.dart';

class AccountRoute {
  static onClickAccountBtn() {
    final pb = Get.put(PBController());

    if (pb.isSignedIn) {
      Get.put(GlobalKeyController()).scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    Get.to(LoginView());
  }
}
