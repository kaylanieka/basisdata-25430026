# Dokumen Kebutuhan Data Koperasi Mahasiswa Sejahtera (Kopma)
**Nama Basis Data:** kopma_026

## 1. Latar Belakang dan Aktivitas Organisasi
Kopma mengelola transaksi penjualan alat tulis, makanan, dan minuman. Pencatatan manual dialihkan ke sistem basis data terstruktur.

## 2. Aktor dan Proses Bisnis
- PB-01: Mendaftarkan Anggota (Aktor: Kasir / Mahasiswa)
- PB-02: Mencatat Penjualan (Aktor: Kasir)
- PB-03: Memesan Barang ke Pemasok (Aktor: Petugas Gudang)
- PB-04: Menerima Barang dari Pemasok (Aktor: Petugas Gudang)
- PB-05: Menyusun Laporan Bulanan (Aktor: Ketua Koperasi)

## 3. Dokumen Sumber yang Dianalisis
Dokumen nota penjualan mencakup: nomor nota, tanggal/jam, kasir, ID anggota, daftar barang, qty, dan harga saat transaksi.

## 4. Entitas Kandidat dan Elemen Data
- Anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, poin_anggota)
- Barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
- Penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
- Detail_Penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
- Petugas (kode_petugas, nama_petugas, peran_petugas)
- Pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok)
- Pembelian & Detail_Pembelian

## 5. Aturan Bisnis
- AB-01: Setiap nota memiliki nomor unik dan minimal satu baris barang.
- AB-02: Penjualan boleh tanpa anggota (pembeli umum); anggota aktif dapat diskon 5%.
- AB-03: Stok barang tidak boleh bernilai negatif (penjualan ditolak jika qty > stok).
- AB-04: Harga jual pada nota disimpan per baris dan tidak berubah meskipun harga barang di katalog naik.
- AB-05: NIM anggota bersifat unik.
- AB-06: Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.
- AB-07: Setiap kelipatan belanja Rp10.000, anggota aktif memperoleh 1 poin. Sebanyak 50 poin dapat ditukarkan dengan potongan belanja Rp5.000.

## 6. Kebutuhan Informasi
- KI-01: Omzet dan jumlah nota per hari dan per bulan.
- KI-02: 5 barang terlaris per bulan.
- KI-03: Barang dengan stok di bawah batas minimum.
- KI-04: 10 anggota dengan belanja terbesar per bulan.
- KI-05: Akumulasi poin dan riwayat penukaran poin tiap anggota.

## 7. Matriks CRUD
| Proses | Anggota | Barang | Penjualan | Detail_Penjualan | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 | C | | | | | |
| PB-02 | R, U | R, U | C | C | | |
| PB-03 | | R | | | R | C |
| PB-04 | | U | | | R | U |
| PB-05 | R | R | R | R | | R |

## 8. Kamus Data Awal
| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 25430026 | Unik, 10 digit | Ketua |
| no_nota_penjualan | Nomor nota | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 | Kasir |
| stok_barang | Jumlah persediaan | 35 | Bilangan bulat >= 0 | Petugas Gudang |
| poin_anggota | Jumlah poin loyalitas | 15 | Bilangan bulat >= 0 | Ketua |

## 9. Kebutuhan Non-Fungsional Data
- Perkiraan volume harian: ~150 nota per hari.
- Retensi data: Disimpan minimal 5 tahun.
- Privasi: Nomor HP anggota bersifat pribadi dan hanya diakses oleh Ketua.

---

## 10. Hasil Latihan dan Modifikasi Modul 2

### A. Penambahan Fitur Poin Loyalitas Anggota
1. **Aturan Bisnis Baru (AB-07):** Setiap kelipatan belanja Rp10.000, anggota aktif memperoleh 1 poin. Sebanyak 50 poin dapat ditukarkan dengan potongan belanja Rp5.000.
2. **Elemen Data Tambahan:** Menambahkan atribut `poin_anggota` pada entitas **Anggota**.
3. **Kebutuhan Informasi Baru (KI-05):** Laporan akumulasi poin dan penukaran poin anggota.
4. **Pembaruan Matriks CRUD:** Pada proses `PB-02` (Mencatat Penjualan), entitas **Anggota** ditambahkan operasi **U (Update)** untuk memperbarui perolehan poin.

### B. Perbaikan Pernyataan Kebutuhan Kabur menjadi Dapat Diuji (Spesifik & Terukur)
1. **Pernyataan Kabur:** *"Data anggota harus aman."*
   - **Dapat Diuji:** Nomor HP anggota bersifat pribadi dan hanya dapat diakses oleh peran Ketua. Peran Kasir ditolak saat mencoba mengakses kolom `no_hp_anggota`.
2. **Pernyataan Kabur:** *"Sistem harus cepat mencari barang."*
   - **Dapat Diuji:** Pencarian data barang berdasarkan `kode_barang` atau `nama_barang` mengembalikan hasil dalam waktu kurang dari 2 detik.
3. **Pernyataan Kabur:** *"Laporan stok harus akurat."*
   - **Dapat Diuji:** Stok barang berkurang secara otomatis saat transaksi penjualan berhasil di-commit dan bertambah saat transaksi penerimaan barang dikonfirmasi. Penjualan ditolak jika `qty` melebihi stok yang tersedia.