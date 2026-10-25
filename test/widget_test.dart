// Pengujian alur utama aplikasi BacaKita (UTS Mobile Programming):
// beranda -> daftar kategori -> detail buku, plus navigasi tab.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_katalog/data/buku_repository.dart';
import 'package:uts_katalog/main.dart';

void main() {
  // Muat JSON sekali di luar zone fake-async: kanal aset platform hanya
  // berhasil untuk pemuatan pertama dalam satu proses `flutter test`.
  setUpAll(() async {
    BukuRepository.sumberUji =
        await rootBundle.loadString('assets/data/buku.json');
  });

  Future<void> bukaAplikasi(WidgetTester tester) async {
    // Kosongkan cache: future dari test sebelumnya dibuat di zone fake-async
    // lain sehingga callback-nya tidak pernah dieksekusi di test ini.
    BukuRepository.resetCache();
    await tester.pumpWidget(const BacaKitaApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Beranda menampilkan koleksi buku dari data dummy JSON',
      (WidgetTester tester) async {
    await bukaAplikasi(tester);

    // Judul aplikasi, banner, dan chip kategori tampil.
    expect(find.text('BacaKita'), findsWidgets);
    expect(find.text('Koleksi Oktober'), findsOneWidget);
    expect(find.text('Fiksi (2)'), findsOneWidget);

    // Data dari file JSON berhasil dimuat dan dirender sebagai rekomendasi.
    expect(find.text('Nusa dalam Kabut'), findsWidgets);
    expect(find.text('Flutter untuk Pemula'), findsWidgets);

    // Gulir ke bawah untuk memastikan seluruh koleksi ikut dirender.
    await tester.drag(find.text('Rekomendasi'), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(find.text('Semua Koleksi'), findsOneWidget);
    expect(find.text('Rahasia Angkasa'), findsOneWidget);
  });

  testWidgets('Navigasi beranda -> daftar kategori -> detail buku',
      (WidgetTester tester) async {
    await bukaAplikasi(tester);

    // Ketuk chip kategori Fiksi -> halaman daftar buku Fiksi.
    await tester.tap(find.text('Fiksi (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Nusa dalam Kabut'), findsOneWidget);
    expect(find.text('Luna dan Bulan Perak'), findsOneWidget);

    // Ketuk satu judul -> halaman detail menampilkan deskripsi buku.
    await tester.tap(find.text('Nusa dalam Kabut'));
    await tester.pumpAndSettle();
    expect(find.text('Deskripsi'), findsOneWidget);
    expect(find.text('oleh Ayu Larasati'), findsOneWidget);
  });

  testWidgets('BottomNavigationBar berpindah ke tab Kategori dan Tentang',
      (WidgetTester tester) async {
    await bukaAplikasi(tester);

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Kategori Buku'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.info_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Deskripsi Aplikasi'), findsOneWidget);
    expect(find.text('Judul Buku'), findsOneWidget);
  });
}