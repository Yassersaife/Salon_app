import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/providers/advertisements_provider.dart';
import 'package:salon_booking_app/providers/booking_provider.dart';
import 'package:salon_booking_app/providers/cart_provider.dart';
import 'package:salon_booking_app/providers/products_provider.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/screens/home_screen.dart';
import 'package:salon_booking_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalonsProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdvertisementsProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),

      ],
      child: MaterialApp(
        title: 'تطبيق ريلاكس',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // دعم اللغة العربية
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', ''), // العربية
        ],
        locale: const Locale('ar', ''),

        home: const HomeScreen(),
      ),
    );
  }
}