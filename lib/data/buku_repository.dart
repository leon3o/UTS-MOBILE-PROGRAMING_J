import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/buku.dart';

/// Sumber data buku (repository).
///
/// Saat ini membaca data dummy dari file JSON lokal `assets/data/buku.json`.
/// Seluruh akses data dilakukan lewat kelas ini, sehingga ketika aplikasi
/// dihubungkan ke server cukup mengganti [_muatDariAsset] dengan permintaan
/// HTTP ke endpoint API tanpa mengubah kode halaman (view).
class BukuRepository {
  /// Hasil pembacaan di-cache supaya file JSON hanya dibaca sekali.
  static Future<List<Buku>>? _cache;

  /// Mengosongkan cache. Hanya dipanggil dari pengujian widget supaya setiap
  /// test memuat ulang aset di zone asinkron miliknya sendiri.
  @visibleForTesting
  static void resetCache() {
    _cache = null;
  }

  /// Sumber JSON alternatif untuk pengujian.
  ///
  /// Diisi sekali dari `setUpAll` (zone asinkron nyata). Pemuatan aset lewat
  /// kanal platform hanya berhasil untuk pemuatan pertama dalam satu proses
  /// `flutter test`, sehingga test kedua dan seterusnya memakai sumber ini
  /// alih-alih memanggil `rootBundle` lagi.
  @visibleForTesting
  static String? sumberUji;

  /// Mengambil seluruh data buku.
  static Future<List<Buku>> muatSemua() {
    debugPrint('[repo] muatSemua dipanggil, cache=${_cache != null}');
    return _cache ??= _muatDariAsset();
  }

  static Future<List<Buku>> _muatDariAsset() async {
    debugPrint('[repo] mulai memuat asset');
    final teks = sumberUji ??
        await rootBundle.loadString('assets/data/buku.json');
    debugPrint('[repo] asset termuat, ${teks.length} karakter');
    final respons = jsonDecode(teks) as Map<String, dynamic>;
    final data = respons['data'] as List<dynamic>;
    return data
        .map((item) => Buku.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Mencari satu buku berdasarkan [id] untuk halaman detail.
  static Future<Buku?> cariBerdasarkanId(int id) async {
    final semua = await muatSemua();
    for (final buku in semua) {
      if (buku.id == id) return buku;
    }
    return null;
  }

  /// Mengambil daftar kategori unik beserta jumlah judul di dalamnya,
  /// digunakan oleh halaman kategori.
  static Future<List<MapEntry<String, int>>> muatKategori() async {
    final semua = await muatSemua();
    final hitung = <String, int>{};
    for (final buku in semua) {
      hitung[buku.kategori] = (hitung[buku.kategori] ?? 0) + 1;
    }
    return hitung.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  /// Menyaring buku milik satu kategori tertentu untuk halaman daftar.
  static Future<List<Buku>> muatBerdasarkanKategori(String kategori) async {
    final semua = await muatSemua();
    return semua.where((buku) => buku.kategori == kategori).toList();
  }
}