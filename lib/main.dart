// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metamorfoz/ui/activity/activity_screen.dart';
import 'package:metamorfoz/ui/activity_tracker/activity_tracker_screen.dart';
import 'package:metamorfoz/ui/auth/login/widgets/login_screen.dart';
import 'package:metamorfoz/ui/camera/widgets/camera_screen.dart';
import 'package:metamorfoz/ui/dashboard/dashboard_screen.dart';
import 'package:metamorfoz/ui/finish_workout/finish_workout_screen.dart';
import 'package:metamorfoz/ui/notification/notification_screen.dart';
import 'package:metamorfoz/ui/on_boarding/on_boarding_screen.dart';
import 'package:metamorfoz/ui/on_boarding/start_screen.dart';
import 'package:metamorfoz/ui/profile/complete_profile_screen.dart';
import 'package:metamorfoz/ui/signup/signup_screen.dart';
import 'package:metamorfoz/ui/welcome/welcome_screen.dart';
import 'package:metamorfoz/ui/your_goal/your_goal_screen.dart';
import 'package:provider/provider.dart';

import 'ui/core/localization/applocalization.dart';
import 'ui/core/themes/theme.dart';
import 'routing/router.dart';
import 'package:flutter/material.dart';

import 'ui/core/ui/scroll_behavior.dart';
import 'main_development.dart' as development;

/// Default main method
void main() {
  // Launch development config by default
  development.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      routes: routes,
      home: DashboardScreen(),
    );



    // return MaterialApp.router(
    //   localizationsDelegates: [
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     AppLocalizationDelegate(),
    //   ],
    //   scrollBehavior: AppCustomScrollBehavior(),
    //   theme: AppTheme.lightTheme,
    //   darkTheme: AppTheme.darkTheme,
    //   themeMode: ThemeMode.system,
    //   routerConfig: router(context.read()),
    // );
  }
}


final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
 // LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  YourGoalScreen.routeName: (context) => const YourGoalScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  FinishWorkoutScreen.routeName: (context) => const FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => const ActivityTrackerScreen(),
 // WorkoutScheduleView.routeName: (context) => const WorkoutScheduleView(),
};