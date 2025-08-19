import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GoRouter routerProvider = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: routerProvider,
      title: 'Kaioras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.violetC2),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.violetC2,
          foregroundColor: AppColors.whiteSmoke,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.violetC2,
          indicatorColor: Colors.white10,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: AppColors.violet99);
            }
            return const TextStyle(color: AppColors.grey, fontSize: 12);
          }),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: AppColors.violetC2,
          indicatorColor: Colors.white10,
          unselectedLabelTextStyle: TextStyle(color: AppColors.black),
          selectedLabelTextStyle: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
