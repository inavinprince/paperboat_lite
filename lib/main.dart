import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperboat_lite/amount_calculator_page.dart';
import 'package:paperboat_lite/app_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Set system UI overlay style based on theme
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: AppTheme.isDarkMode
              ? Brightness.light
              : Brightness.dark, // Icons color
          statusBarBrightness: AppTheme.isDarkMode
              ? Brightness.dark
              : Brightness.light, // For iOS
          systemNavigationBarColor:
              AppTheme.backgroundColor, // Bottom bar color
          systemNavigationBarIconBrightness: AppTheme.isDarkMode
              ? Brightness.light
              : Brightness.dark, // Bottom bar icons
        ));

        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      theme: _buildThemeData(),
      home: const AmountCalculatorPage(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      // Use your theme colors
      primaryColor: AppTheme.primaryColor,
      scaffoldBackgroundColor: AppTheme.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textColor),
      ),
      // This will affect the system navigation bar on some devices
      // bottomAppBarTheme: BottomAppBarTheme(color: AppTheme.backgroundColor),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: AppTheme.backgroundColor,
        surface: AppTheme.surfaceColor,
      ),
    );
  }
}
