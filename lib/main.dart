import 'package:bitbank_app/configs/app_settings.dart';
import 'package:bitbank_app/configs/hive.config.dart';
import 'package:bitbank_app/repositories/favoritas_repository.dart';
import 'package:bitbank_app/repositories/conta_repository.dart';
import 'package:bitbank_app/services/auth_service.dart';
import 'package:bitbank_app/widgets/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Auth_Service()),
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
      home: const AuthCheck(),
    );
  }
}
