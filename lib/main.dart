import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // TODO: عبّي بيانات مشروع Supabase الخاص فيك هنا قبل البناء
  // await Supabase.initialize(
  //   url: 'https://YOUR_PROJECT.supabase.co',
  //   anonKey: 'YOUR_ANON_KEY',
  // );

  runApp(const SharakaApp());
}

class SharakaApp extends StatelessWidget {
  const SharakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'شراكة | Sharaka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // فرض اتجاه RTL على كامل التطبيق بما إن اللغة الأساسية عربي
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
