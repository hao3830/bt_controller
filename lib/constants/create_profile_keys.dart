import 'package:bluetooth_control_path/constants/shared_prefs_keys.dart';

class CreateProfileKeys {
  String profileName;
  String left;
  String right;
  String up;
  String down;

  CreateProfileKeys(
      {this.profileName = "profile",
      this.left = "left",
      this.right = "right",
      this.up = "up",
      this.down = "down"}) {
    SharedPrefsKeys.left = left;
    SharedPrefsKeys.right = right;
    SharedPrefsKeys.up = up;
    SharedPrefsKeys.down = down;
  }
}
