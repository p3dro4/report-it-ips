import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/authentication/authentication.dart';
import 'package:report_it_ips/src/features/main_feed/main_feed.dart';
import 'package:report_it_ips/src/features/register/account_type/account_type.dart';
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
          MaterialPageRoute(builder: (_) => const CustomLoadingPage()),
        );
        VerifyAccount.isProfileComplete().then((isComplete) => {
              _navigatorKey.currentState?.popUntil((route) => route.isFirst),
              if (isComplete)
                {
                  _navigatorKey.currentState?.pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainFeedPage()),
                  )
                }
              else
                {
                  _navigatorKey.currentState?.pushReplacement(
                    MaterialPageRoute(builder: (_) => const AccountTypePage()),
                  )
                }
            });
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
        ).copyWith(
          onBackground: Colors.black,
        ),
        primaryColor: const Color(0xFF948A85),
        primaryColorLight: const Color(0xFFcfcac8),
        brightness: Brightness.light,
        fontFamily: "Roboto",
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
        // ! Uncomment this line to add support for English
        //Locale('en', 'US'),
      ],
      // remove debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
