import 'package:flutter/material.dart';

import '../data/buku_repository.dart';
import '../model/buku.dart';
import '../util/ikon_kategori.dart';

/// Halaman Beranda: pintu masuk utama yang menampilkan kotak pencarian,
/// banner, daftar kategori (horizontal), rekomendasi, dan seluruh koleksi.
/// Navigasi keluar dilakukan lewat [Drawer], [BottomNavigationBar] (milik
/// shell), serta `Navigator.pushNamed` saat kartu buku/kategori diketuk.
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key, required this.onPilihTab});

  /// Callback untuk berpindah tab dari dalam Drawer.
  final void Function(int) onPilihTab;

  @override
  Widget build(BuildContext context) {
    final warnaTema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BacaKita',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: warnaTema.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Text('BacaKita',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white)),
                  Text('Katalog Buku Digital v1.0.0',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context); // tutup drawer
                onPilihTab(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text('Kategori'),
              onTap: () {
                Navigator.pop(context);
                onPilihTab(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);
                onPilihTab(2);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Buku>>(
        future: BukuRepository.muatSemua(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data buku.'));
          }
          final daftarBuku = snapshot.data ?? <Buku>[];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kotak pencarian (elemen UI pencarian pada desain awal).
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cari judul buku...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Banner promosi koleksi bulan ini.
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [warnaTema.primary, warnaTema.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Koleksi Oktober',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            '${daftarBuku.length} judul buku menunggu untuk dibaca',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.local_library_rounded,
                        color: Colors.white, size: 48),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _JudulBagian(label: 'Kategori Buku'),
              const SizedBox(height: 8),

              // Kategori: tap -> halaman daftar buku per kategori.
              FutureBuilder<List<MapEntry<String, int>>>(
                future: BukuRepository.muatKategori(),
                builder: (context, snapshot) {
                  final kategori = snapshot.data ?? <MapEntry<String, int>>[];
                  return SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kategori.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final item = kategori[index];
                        return ActionChip(
                          avatar: Icon(ikonUntukKategori(item.key),
                              size: 18, color: warnaTema.primary),
                          label: Text('${item.key} (${item.value})'),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/daftar',
                            arguments: item.key,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              _JudulBagian(label: 'Rekomendasi'),
              const SizedBox(height: 8),

              // Rekomendasi: kartu horizontal, tap -> halaman detail.
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final buku in daftarBuku
                        .where((b) => b.rating >= 4.5)
                        .take(4))
                      _KartuRekomendasi(
                        buku: buku,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: buku.id,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _JudulBagian(label: 'Semua Koleksi'),
              const SizedBox(height: 8),

              // Seluruh buku, tap -> halaman detail.
              for (final buku in daftarBuku)
                _KartuBuku(
                  buku: buku,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: buku.id,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Label judul bagian yang dipakai konsisten di seluruh beranda.
class _JudulBagian extends StatelessWidget {
  const _JudulBagian({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Kartu rekomendasi (tampilan horizontal, memakai [Container] berwarna
/// sebagai pengganti sampul buku agar tidak bergantung pada gambar jaringan).
class _KartuRekomendasi extends StatelessWidget {
  const _KartuRekomendasi({required this.buku, required this.onTap});

  final Buku buku;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.infinity,
                color: buku.warnaSampul,
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.white, size: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buku.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 16, color: Colors.amber),
                        Text(buku.rating.toString(),
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu buku untuk daftar vertikal di beranda.
class _KartuBuku extends StatelessWidget {
  const _KartuBuku({required this.buku, required this.onTap});

  final Buku buku;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 76,
                decoration: BoxDecoration(
                  color: buku.warnaSampul,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buku.judul,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${buku.penulis} • ${buku.tahun}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.category_rounded,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(buku.kategori,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        const SizedBox(width: 12),
                        const Icon(Icons.star_rounded,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(buku.rating.toString(),
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}