import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/wallet_provider.dart';
import 'presentation/providers/market_provider.dart';
import 'presentation/providers/copy_trade_provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const GMGNApp());
}

class GMGNApp extends StatelessWidget {
  const GMGNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 mini size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => WalletProvider()),
            ChangeNotifierProvider(create: (_) => MarketProvider()),
            ChangeNotifierProvider(create: (_) => CopyTradeProvider()),
          ],
          child: MaterialApp(
            title: 'GMGN.AI Clone',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const App(),
            builder: (context, widget) {
              // Ensure text scale factor is always 1.0 for consistent UI
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
          ),
        );
      },
    );
  }
}