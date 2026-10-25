import 'package:flutter/material.dart';

import '../data/buku_repository.dart';
import '../util/ikon_kategori.dart';

/// Halaman Kategori: menampilkan seluruh kategori buku dalam bentuk grid
/// responsif (jumlah kolom menyesuaikan lebar layar). Ketuk kategori untuk
/// membuka halaman daftar buku milik kategori tersebut.
class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Buku',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<MapEntry<String, int>>>(
        future: BukuRepository.muatKategori(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat kategori.'));
          }
          final kategori = snapshot.data ?? <MapEntry<String, int>>[];

          // Grid responsif: 2 kolom di HP, 3 kolom di tablet/layar lebar.
          return LayoutBuilder(
            builder: (context, constraints) {
              final lebar = constraints.maxWidth;
              final jumlahKolom = lebar > 840 ? 3 : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: jumlahKolom,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemCount: kategori.length,
                itemBuilder: (context, index) {
                  final item = kategori[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/daftar',
                        arguments: item.key,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                ikonUntukKategori(item.key),
                                size: 28,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.key,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text('${item.value} judul',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}