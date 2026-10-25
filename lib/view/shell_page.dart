import 'package:flutter/material.dart';

import 'beranda_page.dart';
import 'kategori_page.dart';
import 'tentang_page.dart';

/// Kerangka utama aplikasi: menggabungkan tiga halaman utama ke dalam satu
/// [BottomNavigationBar] sehingga pengguna dapat berpindah tab tanpa kehilangan
/// posisi halaman (state tiap tab disimpan oleh [IndexedStack]).
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _indexTab = 0;

  void _pindahTab(int index) {
    setState(() => _indexTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indexTab,
        children: [
          BerandaPage(onPilihTab: _pindahTab),
          const KategoriPage(),
          const TentangPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexTab,
        onTap: _pindahTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.info_rounded), label: 'Tentang'),
        ],
      ),
    );
  }
}