import 'package:flutter/material.dart';
import 'package:lazy_easy/core/app_router.dart';
import 'package:lazy_easy/core/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lazy Easy',
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
    );
  }
}
