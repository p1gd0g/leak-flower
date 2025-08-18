import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsController extends GetxController {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
}
