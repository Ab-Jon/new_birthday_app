import 'package:birthday_app/icon_screens/memory_screen.dart';
import 'package:birthday_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  
  Hive.registerAdapter(AlbumAdapter());
  await Hive.openBox<Album>('albums');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abasifreke\'s Birthday!',
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.comicNeueTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

