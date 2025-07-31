import 'package:amazon_clone_app/constants/global_variables.dart';
import 'package:amazon_clone_app/router.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: GlobalVariables.secondaryColor,
          iconTheme: IconThemeData(color: Colors.black),

        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.secondaryColor, // Button background
            foregroundColor: Colors.black, // Button text color
          ),
        ),
      ),
      onGenerateRoute: (settings)=>generateRoute(settings),
      home:const AuthScreen(),
    );
  }
}
