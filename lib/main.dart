import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_recetas/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

import 'package:frontend_recetas/screens/home/main_screen.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'screens/auth/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Modo inmersivo
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //Cargar token antes de iniciar la app
  await ApiService.loadToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteProvider()..loadFavorites(), 
      child: MaterialApp(
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const MainScreen(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}