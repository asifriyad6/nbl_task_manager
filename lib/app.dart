import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/create_task_screen.dart';
import 'package:task_manager/ui/screens/edit_task_screen.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/processing_task_screen.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      routes: {
        SplashScreen.name: (context) => SplashScreen(),
        SigninScreen.name: (context) => SigninScreen(),
        SignUpScreen.name: (context) => SignUpScreen(),
        MainNavBarHolderScreen.name: (context) => MainNavBarHolderScreen(),
        CreateTaskScreen.name: (context) => CreateTaskScreen(),
        EditTaskScreen.name: (context) => EditTaskScreen(),
        NewTaskListScreen.name: (context) => NewTaskListScreen(),
        ProcessingTaskScreen.name: (context) => ProcessingTaskScreen(),
      },
    );
  }
}
