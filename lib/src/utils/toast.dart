import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/providers/toast_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showGlobalToast(
  WidgetRef ref,
  String message, {
  ToastGravity? gravity = ToastGravity.BOTTOM_RIGHT,
  Duration? toastDuration = const Duration(seconds: 5),
}) {
  final toastProvider = ref.read(globalToastProvider);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: AppColors.green92,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: Colors.white),
        SizedBox(width: 12.0),
        Text(message, style: TextStyle(color: Colors.white)),
      ],
    ),
  );

  toastProvider.showToast(
    child: toast,
    gravity: gravity,
    toastDuration: toastDuration!,
  );
}
