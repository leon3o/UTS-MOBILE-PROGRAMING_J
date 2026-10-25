import 'package:flutter/material.dart';

import 'view/daftar_buku_page.dart';
import 'view/detail_buku_page.dart';
import 'view/shell_page.dart';

void main() {
  runApp(const BacaKitaApp());
}

/// Aplikasi BacaKita - Katalog Buku Digital (UTS Mobile Programming).
///
/// Aplikasi memiliki 4 halaman yang saling terhubung lewat navigasi bernama
/// (named routes):
///   1. Shell (Beranda + Kategori + Tentang) -> BottomNavigationBar
///   2. Daftar buku per kategori             -> Navigator.pushNamed('/daftar')
///   3. Detail buku                          -> Navigator.pushNamed('/detail')
class BacaKitaApp extends StatelessWidget {
  const BacaKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BacaKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6CDF)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ShellPage(),
        '/daftar': (context) => DaftarBukuPage(
              kategori:
                  ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/detail': (context) => DetailBukuPage(
              bukuId: ModalRoute.of(context)!.settings.arguments as int,
            ),
      },
    );
  }
}