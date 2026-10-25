import 'package:flutter/material.dart';

import '../data/buku_repository.dart';

/// Halaman Tentang: informasi aplikasi dan ringkasan statistik koleksi,
/// menjadi tab ketiga pada [BottomNavigationBar].
class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: BukuRepository.muatSemua(),
        builder: (context, snapshot) {
          final semua = snapshot.data ?? <dynamic>[];
          final kategori =
              semua.map((b) => b.kategori as String).toSet().length;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 44,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'BacaKita',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text('Katalog Buku Digital • Versi 1.0.0',
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
              const SizedBox(height: 24),

              // Ringkasan statistik koleksi.
              Row(
                children: [
                  Expanded(
                    child: _KartuStatistik(
                        nilai: '${semua.length}', label: 'Judul Buku'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KartuStatistik(
                        nilai: '$kategori', label: 'Kategori'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Deskripsi Aplikasi',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'BacaKita adalah aplikasi katalog buku yang menampilkan '
                'koleksi buku dummy dari file JSON lokal. Aplikasi ini '
                'dirancang sebagai prototipe antarmuka mobile dengan konsep '
                'layout, widget, dan navigasi antar halaman menggunakan '
                'framework Flutter, sekaligus disiapkan agar sumber data '
                'mudah dipindahkan ke API server pada pengembangan '
                'berikutnya.',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.6),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'UTS Mobile Programming • Semester Ganjil 2025/2026',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Kartu statistik sederhana pada halaman Tentang.
class _KartuStatistik extends StatelessWidget {
  const _KartuStatistik({required this.nilai, required this.label});

  final String nilai;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            nilai,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}