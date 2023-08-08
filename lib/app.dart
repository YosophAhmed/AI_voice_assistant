import 'package:flutter/material.dart';
import 'package:voice_assistant/core/app_colors.dart';

import 'presentation/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Voice Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.whiteColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.whiteColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
