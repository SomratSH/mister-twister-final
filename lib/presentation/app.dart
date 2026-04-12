import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_routes.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/provider_list.dart';
import 'package:provider/provider.dart';

class MisterTwister extends StatelessWidget {
  final GoRouter router;
  const MisterTwister({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MultiProvider(
          providers: AppProvider.provider,

          child: MaterialApp.router(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(color: AppColors.textDark),
                hintStyle: const TextStyle(color: AppColors.textGrayLight),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.textDark,
                selectionColor: AppColors.primaryPink,
                selectionHandleColor: AppColors.primaryPink,
              ),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
