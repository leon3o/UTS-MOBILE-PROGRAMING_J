import 'package:flutter/material.dart';

/// Model data buku.
///
/// Struktur field sengaja disusun menyerupai objek respons API REST (snake/
/// plain keys, tipe data primitif) agar pada tahap pengembangan berikutnya
/// sumber data tinggal diganti dari file JSON lokal menjadi permintaan HTTP
/// ke server tanpa mengubah bentuk objek yang digunakan oleh halaman/view.
class Buku {
  final int id;
  final String judul;
  final String penulis;
  final String kategori;
  final int tahun;
  final String penerbit;
  final double rating;
  final String warna; // kode heksadesimal sampul, contoh: "#6C63FF"
  final String deskripsi;

  const Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.tahun,
    required this.penerbit,
    required this.rating,
    required this.warna,
    required this.deskripsi,
  });

  /// Mengubah JSON per item menjadi objek [Buku].
  factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        id: json['id'] as int,
        judul: json['judul'] as String,
        penulis: json['penulis'] as String,
        kategori: json['kategori'] as String,
        tahun: json['tahun'] as int,
        penerbit: json['penerbit'] as String,
        rating: (json['rating'] as num).toDouble(),
        warna: json['warna'] as String,
        deskripsi: json['deskripsi'] as String,
      );

  /// Mengubah objek [Buku] kembali ke JSON (berguna saat nanti disimpan ke
  /// server melalui API).
  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'penulis': penulis,
        'kategori': kategori,
        'tahun': tahun,
        'penerbit': penerbit,
        'rating': rating,
        'warna': warna,
        'deskripsi': deskripsi,
      };

  /// Warna sampul bertipe [Color] hasil konversi string "#RRGGBB".
  Color get warnaSampul =>
      Color(int.parse(warna.substring(1), radix: 16) + 0xFF000000);
}