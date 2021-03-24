import 'SharedPreferenceUtil.dart';

class Global {
  static Future init() async {}

  static PersistentStorage getPref() {
    return PersistentStorage();
  }
}
