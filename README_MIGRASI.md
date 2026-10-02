# KARIER — Paket lengkap migrasi

Snapshot diambil langsung dari aplikasi aktif pada 2 Oktober 2026. Source commit: e05d086bffc93da05c9d83f87d0d543fe9780146.

## Isi
- source/: source aplikasi React/TypeScript, API, logo, konfigurasi, dependency lockfile, dan riwayat migrasi schema.
- database/karier-data.json: semua data aplikasi yang sedang aktif (warga, iuran, pengeluaran/pemasukan, pinjaman, pengembalian, pemindahan dana).
- database/karier-restore.sql: schema dan data siap diimpor ke database D1 kosong.
- database/karier.sqlite: salinan database yang dapat dibuka dengan DB Browser for SQLite.
- database/ringkasan-verifikasi.json: jumlah catatan, saldo, dan waktu pengambilan.
- migration/prepare-cloudflare.mjs: penyesuaian konfigurasi hasil build untuk domain dan D1 milik Anda.

## Hosting yang sesuai
Aplikasi memakai Cloudflare Workers + D1, bukan PHP/MySQL. Domain baru dapat dipasang pada Workers dengan domain yang dikelola pada akun Cloudflare Anda. Hosting cPanel/PHP biasa memerlukan porting backend; paket ini tidak mengubahnya menjadi PHP. File JSON/SQL adalah snapshot, bukan sinkronisasi otomatis dengan situs lama.

## Persiapan
1. Siapkan domain pada akun Cloudflare Anda dan akun yang dapat membuat Workers serta D1.
2. Instal Node.js 22.13 atau lebih baru dan npm. Ekstrak ZIP, buka terminal di folder source.
3. Instal dependency sesuai lockfile:
   npm run install:ci
4. Masuk ke akun Cloudflare:
   npx wrangler login
5. Buat database milik Anda:
   npx wrangler d1 create karier-db
   Salin database_id yang ditampilkan. Jangan memakai ID database situs lama.
6. Bangun aplikasi:
   npm run build
7. Sesuaikan database dan domain, ganti ID_DATABASE dan karier.domainanda.id:
   node ../migration/prepare-cloudflare.mjs ID_DATABASE karier.domainanda.id
8. Impor snapshot ke database BARU/KOSONG:
   npx wrangler d1 execute karier-db --remote --config wrangler.migration.json --file ../database/karier-restore.sql
   Jangan mengimpor dua kali. Jangan menjalankan seluruh migration SQL lama setelah snapshot diimpor: beberapa file lama berisi koreksi/transaksi historis yang sudah terselesaikan pada snapshot.

## Lindungi aplikasi sebelum digunakan
Situs lama mendapat perlindungan login dari platform Sites. Perlindungan tersebut tidak ikut berpindah hanya dengan menyalin source; API aplikasi tidak memiliki akun/password mandiri. Siapkan kebijakan Cloudflare Access untuk domain baru, batasi akun pengelola yang boleh membuka aplikasi, dan pastikan kebijakan juga melindungi /api/* sebelum membuka akses aplikasi. Matikan workers.dev alternatif (helper menetapkan workers_dev=false) agar akses tidak melewati perlindungan domain.

## Terbitkan ke akun Anda
   npx wrangler deploy --config dist/server/wrangler.json
Helper mempertahankan path Worker dan aset hasil build. Jalankan ulang helper setelah setiap npm run build sebelum deploy berikutnya, karena konfigurasi build dapat kembali memakai database placeholder.

## Uji setelah migrasi
- Login sebagai pengelola melalui Access. Pastikan pengguna tanpa izin tidak dapat membuka halaman maupun /api/state.
- Pastikan 39 warga, 25 pembayaran, 15 transaksi kas, 0 pinjaman, 0 pengembalian, dan 2 pemindahan dana sesuai snapshot ini.
- Bandingkan saldo pada periode Oktober 2026 atau periode terakhir dengan ringkasan-verifikasi.json.
- Uji menu Buku Kas, posisi wallet, status iuran, empat pilihan laporan, CSV, diagram dan cetak/simpan PDF.
- Sebelum beralih, hentikan sementara input di situs lama dan ambil snapshot terakhir bila ada transaksi baru. Pilih satu situs sebagai sumber input agar data tidak bercabang.
- Simpan situs lama sampai pengecekan selesai. Menghubungkan domain baru tidak menghapus situs lama.

## Batas paket
Paket memuat source dan seluruh data aplikasi dari API aktif. Token login, credential repositori, password, akun Cloudflare, log akses, node_modules, dan file build sementara tidak disertakan. Metadata login platform Sites bukan database KARIER. Hosting/domain tetap harus disiapkan di akun Anda. SQL restore sudah diuji pada SQLite dengan pemeriksaan foreign key dan jumlah baris; deployment ke akun/domain Anda belum dilakukan karena domain dan akun tujuan belum diberikan.
