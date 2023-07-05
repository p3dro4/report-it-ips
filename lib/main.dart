import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/authentication/authentication.dart';
import 'package:report_it_ips/src/features/main_feed/main_feed.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _navigatorKey.currentState?.popUntil((route) => route.isFirst);
      if (user == null) {
        // User is not logged in
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        // User is logged in
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const MainFeedPage()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: const LoginPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColorGenerator.from(const Color(0xFF948A85)),
          backgroundColor: Colors.white,
        ),
        primaryColor: const Color(0xFF948A85),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[500],
          ),
        ),
        primaryColorLight: const Color(0xFFcfcac8),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'PT'),
        //Locale('en', 'US'),
      ],
      // remove debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
