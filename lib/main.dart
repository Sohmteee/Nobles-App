import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/homepage.dart';

void main() {
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noble\'s App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Nexa",
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
