import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

final globalToastProvider = Provider((Ref ref) {
  final fToast = FToast();
  fToast.init(rootNavigatorKey.currentContext!);
  return fToast;
});
