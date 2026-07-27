// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_almacenamiento_local/view/splash_page.dart';
import 'core/theme/app_theme.dart';
import 'view/main_page.dart';
import 'viewmodel/pin_viewmodel.dart';
import 'viewmodel/contacto_viewmodel.dart';
import 'viewmodel/theme_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PinViewModel()),
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeViewModel.loadTheme();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashPage(),
    );
  }
}