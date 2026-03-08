import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/app_providers.dart';
import 'utils/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/language_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/shell_screens.dart';
import 'screens/customer/product_detail_screen.dart';
import 'screens/customer/cart_screen.dart';
import 'screens/customer/orders_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Immersive status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const TwendeMarkitiApp());
}

class TwendeMarkitiApp extends StatelessWidget {
  const TwendeMarkitiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => CustomersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer2<LanguageProvider, AuthProvider>(
        builder: (_, lang, auth, __) => MaterialApp(
          title: 'Twende Markiti',
          debugShowCheckedModeBanner: false,
          // ── Theme ────────────────────────────────────
          theme: auth.isAdmin ? TM.adminTheme() : TM.customerTheme(),
          // ── Localization ─────────────────────────────
          locale: lang.locale,
          supportedLocales: const [
            Locale('sw'), // Kiswahili
            Locale('en'), // English
            Locale('fr'), // Français
            Locale('ar'), // العربية
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // ── Routes ───────────────────────────────────
          initialRoute: '/splash',
          routes: {
            '/splash':    (_) => const SplashScreen(),
            '/language':  (_) => const LanguageScreen(),
            '/login':     (_) => const LoginScreen(),
            '/register':  (_) => const RegisterScreen(),
            '/home':      (_) => const CustomerShell(),
            '/admin':     (_) => const AdminShell(),
            '/cart':      (_) => const CartScreen(),
            '/orders':    (_) => const OrdersScreen(),
            '/profile':   (_) => const ProfileScreen(),
            '/notifications': (_) => const NotificationsScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/product':
                return MaterialPageRoute(
                  builder: (_) => const ProductDetailScreen(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(builder: (_) => const SplashScreen());
            }
          },
        ),
      ),
    );
  }
}
