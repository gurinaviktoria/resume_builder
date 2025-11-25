import 'package:flutter/foundation.dart'; // Для kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Sqflite
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'theme_provider.dart';
import 'routes/app_router.dart';
import 'viewmodels/home_viewmodel.dart';
import 'app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ініціалізація sqflite для Web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const ResumeApp(),
    ),
  );
}

class ResumeApp extends StatelessWidget {
  const ResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Resume Builder',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
