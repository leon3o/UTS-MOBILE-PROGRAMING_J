import 'package:flutter/material.dart';

import '../data/buku_repository.dart';
import '../model/buku.dart';

/// Halaman Daftar Buku: menampilkan seluruh buku milik satu kategori
/// (diterima melalui argumen route `/daftar`). Ketuk salah satu item untuk
/// membuka halaman detail buku.
class DaftarBukuPage extends StatelessWidget {
  const DaftarBukuPage({super.key, required this.kategori});

  final String kategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kategori,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Buku>>(
        future: BukuRepository.muatBerdasarkanKategori(kategori),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat daftar buku.'));
          }
          final daftar = snapshot.data ?? <Buku>[];

          if (daftar.isEmpty) {
            return const Center(
              child: Text('Belum ada buku pada kategori ini.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: daftar.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final buku = daftar[index];
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: Container(
                    width: 44,
                    height: 60,
                    decoration: BoxDecoration(
                      color: buku.warnaSampul,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.menu_book_rounded, color: Colors.white),
                  ),
                  title: Text(
                    buku.judul,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${buku.penulis} • ${buku.penerbit}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 18, color: Colors.amber),
                      Text(buku.rating.toString()),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.grey),
                    ],
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: buku.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}