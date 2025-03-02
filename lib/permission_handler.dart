import 'package:permission_handler/permission_handler.dart';

bool isPermissionGranted = false;

Future<void> updatePermissionStatus() async {
  PermissionStatus smsStatus = await Permission.sms.status;
  PermissionStatus contactsStatus = await Permission.contacts.status;
  bool status = smsStatus.isGranted && contactsStatus.isGranted;
  isPermissionGranted = status;
}

Future<void> requestPermission() async {
  PermissionStatus smsStatus = await Permission.sms.request();
  PermissionStatus contactsStatus = await Permission.contacts.request();
  bool status = smsStatus.isGranted && contactsStatus.isGranted;
  isPermissionGranted = status;
}
