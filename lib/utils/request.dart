import 'package:permission_handler/permission_handler.dart';

requestPermission(List<Permission> permissions) async {
  for (Permission permission in permissions) {
    if (await permission.isGranted) {
      return true;
    } else {
      await permission.request();
      if (await permission.isDenied) {
        return true;
      }
      if (await permission.isDenied) {
        return false;
      }
    }
  }
}
