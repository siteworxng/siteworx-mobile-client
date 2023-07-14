import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'constant.dart';

class Permissions {
  static PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

  static Future<bool> cameraFilesAndLocationPermissionsGranted() async {
    if (!getBoolAsync(PERMISSION_STATUS)) {
      Map<Permission, PermissionStatus> cameraPermissionStatus = await _handler.requestPermissions(
        [
          Permission.camera,
          Permission.location,
          if (isIOS) Permission.locationAlways,
          if (isIOS) Permission.locationWhenInUse,
        ],
      );

      bool checkedTrue = true;
      cameraPermissionStatus.values.forEach((element) {
        if (element == PermissionStatus.granted) {
          checkedTrue = true;
        } else if (element == PermissionStatus.permanentlyDenied) {
          openAppSettings();
          checkedTrue = false;
        } else {
          checkedTrue = false;
        }
      });

      return checkedTrue;
    }

    return true;
  }
}
