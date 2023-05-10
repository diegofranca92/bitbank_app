import 'package:bitbank_app/configs/app_settings.dart';
import 'package:bitbank_app/configs/hive.config.dart';
import 'package:bitbank_app/pages/home_page.dart';
import 'package:bitbank_app/repositories/favoritas_repository.dart';
import 'package:bitbank_app/repositories/conta_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppSettings()),
    ChangeNotifierProvider(create: (context) => FavoritasRepository()),
    ChangeNotifierProvider(create: (context) => ContaRepository())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bit Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
    );
  }
}
