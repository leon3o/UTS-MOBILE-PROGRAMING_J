import 'package:flutter/material.dart';

import '../data/buku_repository.dart';
import '../model/buku.dart';
import '../util/ikon_kategori.dart';

/// Halaman Detail Buku: menampilkan informasi lengkap satu buku yang diterima
/// melalui argumen route `/detail` (berupa id buku).
class DetailBukuPage extends StatelessWidget {
  const DetailBukuPage({super.key, required this.bukuId});

  final int bukuId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Buku?>(
        future: BukuRepository.cariBerdasarkanId(bukuId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final buku = snapshot.data;
          if (buku == null) {
            return const Center(child: Text('Buku tidak ditemukan.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sampul buku (warna tematik) + judul dan penulis.
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: buku.warnaSampul.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 150,
                      decoration: BoxDecoration(
                        color: buku.warnaSampul,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      buku.judul,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('oleh ${buku.penulis}',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ringkasan informasi dalam bentuk daftar baris.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _BarisInfo(
                        ikon: ikonUntukKategori(buku.kategori),
                        label: 'Kategori',
                        nilai: buku.kategori,
                      ),
                      const Divider(),
                      _BarisInfo(
                        ikon: Icons.calendar_month_rounded,
                        label: 'Tahun Terbit',
                        nilai: '${buku.tahun}',
                      ),
                      const Divider(),
                      _BarisInfo(
                        ikon: Icons.business_rounded,
                        label: 'Penerbit',
                        nilai: buku.penerbit,
                      ),
                      const Divider(),
                      _BarisInfo(
                        ikon: Icons.star_rounded,
                        label: 'Rating',
                        nilai: '${buku.rating} / 5.0',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Deskripsi',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                buku.deskripsi,
                textAlign: TextAlign.justify,
                style: const TextStyle(height: 1.6),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

/// Baris informasi (ikon + label + nilai) yang dipakai pada kartu ringkasan.
class _BarisInfo extends StatelessWidget {
  const _BarisInfo({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        const Spacer(),
        Text(nilai, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}