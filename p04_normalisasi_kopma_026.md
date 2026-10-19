# Dokumen Normalisasi Basis Data Kopma - Modul 4
**Nama:** Kaylani Eka Putri Damayanti
**NIM:** 25430026
**Kelas:** A

---

## D. Langkah Percobaan

### D.1 Dari UNF ke 1NF

1. **Unnormalized Form (UNF)**
Grup berulang disimpan dalam satu baris nota:
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan }, jumlah_penjualan, diskon_penjualan, total_penjualan)

2. **First Normal Form (1NF)**
Menghilangkan grup berulang sehingga setiap baris bernilai atomik dengan Kunci Primer Komposit:
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)

---

### D.2 Dependensi Fungsional (FD)

- **FD1:** no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota (AB-01)
- **FD3:** no_anggota -> nama_anggota (AB-05)
- **FD4:** kode_barang -> nama_barang
- **FD5:** (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan (AB-04)
- **FD6:** qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan (Nilai Turunan)

---

### D.3 Menuju 2NF dan 3NF

1. **Second Normal Form (2NF)**
Menghilangkan ketergantungan parsial pada kunci komposit:
- **penjualan:** (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota)
- **detail_penjualan:** (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
- **barang:** (kode_barang, nama_barang)

2. **Third Normal Form (3NF)**
Menghilangkan ketergantungan transitif antar atribut bukan kunci:
- **PETUGAS:** (kode_petugas, nama_petugas)
- **ANGGOTA:** (no_anggota, nama_anggota)
- **PENJUALAN:** (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
- **DETAIL_PENJUALAN:** (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
- **BARANG:** (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)

3. **Keputusan Nilai Turunan**
Nilai turunan seperti `subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` **tidak disimpan** dalam tabel operasional untuk mengelakkan anomali dan ketidakselarasan data.

---

### Jawaban Titik Analisis

1. **Titik Analisis 1:** `harga_satuan_detail_penjualan` diletakkan pada kunci komposit `(no_nota_penjualan, kode_barang)` mengikut aturan AB-04 supaya harga pada nota lama tidak berubah apabila harga di tabel `barang` dinaikkan di kemudian hari.
2. **Titik Analisis 2:** Keputusan untuk tidak menyimpan `total` di tabel operasional mengekalkan konsistensi data. Walau bagaimanapun, untuk data arsip/historis yang tidak lagi berubah, nilai total boleh disimpan.
3. **Titik Analisis 3:** Informasi pemasok tidak disimpan di tabel `barang` tetapi dicatat melalui riwayat pembelian (`pembelian` dan `detail_pembelian`), membolehkan Kopma berganti pemasok tanpa merusak data barang.

---

## E. Hasil Latihan dan Modifikasi

1. **Normalisasi Beberapa Nomor Telepon Pemasok**
   - **Masalah:** Menyimpan beberapa nomor telepon dalam satu kolom melanggar 1NF.
   - **Solusi 3NF:** Membuat tabel terpisah `telepon_pemasok`.
   - **Relasi Baru:**
     - `pemasok` (`id_pemasok`, `nama_pemasok`, `alamat_pemasok`)
     - `telepon_pemasok` (`id_telepon`, `id_pemasok`*, `no_telepon`)

2. **Contoh Pelanggaran 3NF dan Anomali Ubah**
   - **Bentuk Pelanggaran:** Ketergantungan transitif `id_penjualan -> id_anggota -> nama_anggota`.
   - **Contoh Data Bermasalah:**
     - id_penjualan: 1 | id_anggota: 5 | nama_anggota: Budi Santoso
     - id_penjualan: 2 | id_anggota: 5 | nama_anggota: Budi Santoso
   - **Anomali Ubah:** Mengubah nama Budi pada satu baris saja menyebabkan data nama untuk `id_anggota` 5 menjadi tidak konsisten.
   - **Kueri Ubah yang Memperlihatkan Anomali:**
     ```sql
     UPDATE penjualan 
     SET nama_anggota = 'Budi Setiawan' 
     WHERE id_penjualan = 1;
     ```