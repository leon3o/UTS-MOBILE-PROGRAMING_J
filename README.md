# BacaKita — Katalog Buku Digital

Aplikasi mobile Flutter untuk Ujian Tengah Semester (UTS) mata kuliah **Mobile Programming**.
Tema aplikasi adalah **katalog buku digital**: pengguna dapat menelusuri koleksi buku,
menyaringnya per kategori, dan membaca detail tiap judul. Tema dipilih karena relevan dengan
kebiasaan membaca digital dan memberi ruang menampilkan data terstruktur (daftar → kategori →
detail) yang merupakan inti ketentuan UTS: layout, widget, dan navigasi antar halaman.

## Tujuan Aplikasi

- Menampilkan koleksi buku dummy dari file JSON lokal secara terstruktur dan mudah dibaca.
- Menerapkan layout dan widget Flutter (Row, Column, Container, ListView, Card, GridView, dll.)
  dengan prinsip responsive design.
- Mengimplementasikan navigasi: `BottomNavigationBar` untuk tab utama dan
  `Navigator.pushNamed` (named routes) untuk halaman daftar dan detail.
- Menyiapkan struktur data agar mudah diganti dengan permintaan API di pengembangan berikutnya.

## Daftar Halaman dan Fungsi

| Halaman | Berkas | Fungsi |
|---|---|---|
| Beranda | `lib/view/beranda_page.dart` | Banner koleksi bulan ini, chip kategori, dan daftar rekomendasi buku (ListView) |
| Kategori | `lib/view/kategori_page.dart` | Grid kategori buku beserta jumlah judul pada tiap kategori |
| Tentang | `lib/view/tentang_page.dart` | Deskripsi aplikasi, judul, dan informasi penulis |
| Daftar Buku | `lib/view/daftar_buku_page.dart` | Daftar buku milik satu kategori (dibuka lewat route `/daftar`) |
| Detail Buku | `lib/view/detail_buku_page.dart` | Informasi lengkap buku: penulis, tahun, penerbit, sinopsis (dibuka lewat route `/detail`) |
| Shell | `lib/view/shell_page.dart` | Kerangka utama: menggabungkan Beranda/Kategori/Tentang dalam `BottomNavigationBar` + `IndexedStack` |

Struktur data ada di `lib/model/buku.dart` (kelas `Buku` + `Buku.fromJson`), sumber data di
`lib/data/buku_repository.dart`, dan data dummy di `assets/data/buku.json`.

## Navigasi

- Tab Beranda / Kategori / Tentang → `BottomNavigationBar` (state tiap tab disimpan `IndexedStack`).
- Chip kategori & item kategori → `Navigator.pushNamed('/daftar', arguments: kategori)`.
- Kartu buku → `Navigator.pushNamed('/detail', arguments: idBuku)`.
- Route didefinisikan sekali di `lib/main.dart` pada properti `routes` MaterialApp.

## Menjalankan Aplikasi

Prasyarat: Flutter SDK terpasang (cek dengan `flutter doctor`).

```bash
flutter pub get      # unduh dependensi
flutter run          # jalankan di emulator/perangkat Android
```

Perintah lain yang berguna:

```bash
flutter analyze      # periksa kualitas kode (tanpa error)
flutter test         # jalankan pengujian widget (3 test lulus)
flutter build apk    # bangun APK Android
flutter build web    # bangun versi web
```

## Pengujian

`test/widget_test.dart` menguji tiga alur utama:

1. Beranda menampilkan koleksi buku dari data dummy JSON (banner, chip kategori, daftar judul).
2. Navigasi Beranda → daftar kategori → detail buku.
3. `BottomNavigationBar` berpindah ke tab Kategori dan Tentang.

## Pengembangan Lanjutan (API)

Seluruh akses data dipusatkan di `BukuRepository`. Untuk menghubungkan ke server, ganti
`_muatDariAsset()` dengan permintaan HTTP ke endpoint API — halaman tidak perlu diubah.
