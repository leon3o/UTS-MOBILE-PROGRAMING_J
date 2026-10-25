import 'package:flutter/material.dart';

/// Pemetaan nama kategori ke ikon Material agar tampilan konsisten di
/// seluruh halaman (beranda, kategori, daftar, dan detail).
IconData ikonUntukKategori(String kategori) {
  switch (kategori) {
    case 'Fiksi':
      return Icons.auto_stories_rounded;
    case 'Sains':
      return Icons.science_rounded;
    case 'Teknologi':
      return Icons.devices_rounded;
    case 'Sejarah':
      return Icons.account_balance_rounded;
    case 'Pengembangan Diri':
      return Icons.self_improvement_rounded;
    default:
      return Icons.category_rounded;
  }
}