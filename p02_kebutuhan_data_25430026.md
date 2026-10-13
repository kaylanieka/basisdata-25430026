# Dokumen Kebutuhan Data Klinik Sehat Bersama 026
**Nama Basis Data:** klinik_026  
**Penyusun:** Kaylani Eka Putri Damayanti (25430026)  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Klinik Sehat Bersama 026 mengelola pelayanan pendaftaran pasien, pemeriksaan medis oleh dokter, pemberian tindakan medis, serta resep obat. Pencatatan manual menimbulkan risiko rekam medis ganda dan selisih stok obat. Sistem basis data ini dirancang untuk mengintegrasikan seluruh proses operasional klinik secara terstruktur dan efisien.

---

## 2. Aktor dan Proses Bisnis
- **PB-01: Mendaftarkan Pasien Baru & Kunjungan** (Aktor: Resepsionis / Pasien)
- **PB-02: Mencatat Pemeriksaan Medis & Diagnosa** (Aktor: Dokter)
- **PB-03: Menginput Tindakan Medis Transaksi** (Aktor: Dokter / Perawat)
- **PB-04: Menginput Resep Obat Transaksi** (Aktor: Dokter / Apoteker)
- **PB-05: Pengelolaan Persediaan Stok Obat** (Aktor: Petugas Apotek)
- **PB-06: Menyusun Laporan Rekapitulasi Pelayanan** (Aktor: Kepala Klinik)

---

## 3. Dokumen Sumber Fiktif dan Pembedahan Elemen Data

### A. Dokumen Sumber: Formulir Lembar Pemeriksaan & Resep Pasien
- **Header:** Nama Klinik, Tanggal Pendaftaran, Nomor Pendaftaran, Nama Pasien, Nomor RM.
- **Data Dokter:** Nama Dokter, Spesialis, Nomor SIP.
- **Rincian Pemeriksaan:** Tanggal Pemeriksaan, Diagnosa Medis.
- **Tindakan & Resep:** Nama Tindakan, Tarif Satuan, Jumlah (Qty), Nama Obat, Aturan Pakai.

### B. Pembedahan Elemen Data
1. **Elemen Disimpan:** `no_rm`, `nik_pasien`, `no_pendaftaran`, `id_dokter`, `tgl_pemeriksaan`, `diagnosa_pemeriksaan`, `id_tindakan`, `tarif_satuan_detail_tindakan`, `id_obat`, `aturan_pakai_resep_detail`, `qty_resep_detail`.
2. **Elemen Kalkulasi (Tidak Disimpan):** `total_biaya_tindakan`, `total_biaya_obat`, `grand_total_pembayaran`.

---

## 4. Entitas Kandidat dan Elemen Data (Sesuai Diagram ERD Modul 3)
1. **pasien:** `id_pasien` (PK), `no_rm` (AK), `nik_pasien` (AK), `nama_pasien`, `tgl_lahir_pasien`, `no_hp_pasien`.
2. **dokter:** `id_dokter` (PK), `kd_dokter` (AK), `sip_dokter` (AK), `nama_dokter`, `spesialis_dokter`, `tarif_konsultasi_dokter`.
3. **pendaftaran:** `id_pendaftaran` (PK), `no_pendaftaran` (AK), `id_pasien` (FK), `tgl_pendaftaran`.
4. **pemeriksaan:** `id_pemeriksaan` (PK), `id_pendaftaran` (FK), `id_dokter` (FK), `tgl_pemeriksaan`, `diagnosa_pemeriksaan`.
5. **detail_tindakan:** `id_pemeriksaan` (PK, FK), `id_tindakan` (PK, FK), `qty_detail_tindakan`, `tarif_satuan_detail_tindakan`.
6. **tindakan:** `id_tindakan` (PK), `kd_tindakan` (AK), `nama_tindakan`, `tarif_tindakan`.
7. **resep_detail:** `id_pemeriksaan` (PK, FK), `id_obat` (PK, FK), `qty_resep_detail`, `aturan_pakai_resep_detail`.
8. **obat:** `id_obat` (PK), `kd_obat` (AK), `nama_obat`, `stok_obat`.

---

## 5. Aturan Bisnis
- **AB-01:** Nomor Rekam Medis (`no_rm`) dan NIK (`nik_pasien`) bersifat unik dan tidak boleh ganda[cite: 9].
- **AB-02:** Setiap pendaftaran harus terhubung dengan tepat satu data pasien terdaftar[cite: 9].
- **AB-03:** Pasien dapat melakukan pendaftaran berulang kali untuk kunjungan berobat yang berbeda (`1` ke `0..N`)[cite: 9].
- **AB-04:** Satu sesi pendaftaran diproses dalam maksimal satu kali pemeriksaan (`1` ke `0..1`)[cite: 9].
- **AB-05:** Batas maksimal obat yang dapat diberikan dalam 1 resep pemeriksaan adalah **11 item** (Parameter $P + 2 = 9 + 2$).
- **AB-06:** Denda keterlambatan pembayaran tagihan instansi mitra ditetapkan sebesar **Rp9.000 per hari** (Parameter $P$).
- **AB-07:** Tarif satuan tindakan pada `detail_tindakan` disimpan per baris transaksi agar nilainya tidak berubah jika daftar harga master tindakan diperbarui[cite: 9].
- **AB-08:** Pengurangan stok obat terjadi secara otomatis saat detail resep obat diinput pada sesi pemeriksaan[cite: 9].

---

## 6. Kebutuhan Informasi
- **KI-01:** Laporan rekapitulasi jumlah pendaftaran kunjungan pasien harian dan bulanan[cite: 9].
- **KI-02:** 5 tindakan medis yang paling sering diberikan berdasarkan catatan `detail_tindakan`[cite: 9].
- **KI-03:** Daftar obat dengan persediaan `stok_obat` yang menipis/kritis[cite: 9].
- **KI-04:** Laporan rekapitulasi jumlah sesi pemeriksaan medis per dokter penanggung jawab[cite: 9].
- **KI-05:** Riwayat diagnosa medis dan rekam kesehatan pasien berdasarkan `no_rm`[cite: 9].

---

## 7. Matriks CRUD

| Proses Bisnis | pasien | dokter | pendaftaran | pemeriksaan | detail_tindakan | tindakan | resep_detail | obat |
|---|---|---|---|---|---|---|---|---|
| **PB-01 (Pendaftaran Pasien)** | C, R | R | C, R | | | | | |
| **PB-02 (Pemeriksaan Dokter)** | R | R | U | C, R | | | | |
| **PB-03 (Input Detail Tindakan)** | R | | | R | C, R | R | | |
| **PB-04 (Input Resep Obat)** | R | | | R | | | C, R | R, U |
| **PB-05 (Pengelolaan Stok Obat)** | | | | | | | | C, R, U |
| **PB-06 (Laporan Rekapitulasi)** | R | R | R | R | R | R | R | R |

---

## 8. Kamus Data Awal (Sesuai Atribut Diagram ERD)

| Elemen Data | Arti / Deskripsi | Contoh Nilai | Aturan Bisnis / Batasan | Penanggung Jawab |
|---|---|---|---|---|
| `id_pasien` | Identifier unik pasien | 1001 | Primary Key, Auto-increment | Resepsionis |
| `no_rm` | Nomor rekam medis pasien | RM-026-001 | Alternate Key, Unik | Resepsionis |
| `nik_pasien` | NIK KTP pasien | 1871025609010001 | Alternate Key, Unik 16 digit | Resepsionis |
| `nama_pasien` | Nama lengkap pasien | Ahmad Dahlan | Teks, Wajib diisi | Resepsionis |
| `tgl_lahir_pasien` | Tanggal lahir pasien | 1998-05-14 | Format YYYY-MM-DD | Resepsionis |
| `no_hp_pasien` | Nomor kontak/WA pasien | 081234567890 | 10-13 digit angka, Data Pribadi | Resepsionis |
| `id_dokter` | Identifier unik dokter | 201 | Primary Key, Auto-increment | Kepala Klinik |
| `kd_dokter` | Kode unik dokter | DOC-026 | Alternate Key, Unik | Kepala Klinik |
| `sip_dokter` | Nomor Surat Izin Praktik | SIP/2026/026 | Alternate Key, Unik | Kepala Klinik |
| `nama_dokter` | Nama dokter penanggung jawab | dr. Siti Rahma | Teks, Wajib diisi | Kepala Klinik |
| `spesialis_dokter` | Bidang spesialisasi dokter | Dokter Umum | Teks | Kepala Klinik |
| `tarif_konsultasi_dokter` | Jasa tarif konsultasi | 150000 | Angka >= 0 | Kepala Klinik |
| `id_pendaftaran` | Identifier unik pendaftaran | 5001 | Primary Key, Auto-increment | Resepsionis |
| `no_pendaftaran` | Nomor antrean pendaftaran | REG-2610-01 | Alternate Key, Unik per hari | Resepsionis |
| `tgl_pendaftaran` | Tanggal & waktu daftar | 2026-10-11 | Format YYYY-MM-DD | Resepsionis |
| `id_pemeriksaan` | Identifier unik pemeriksaan | 7001 | Primary Key, Auto-increment | Dokter |
| `tgl_pemeriksaan` | Tanggal pelaksanaan periksa | 2026-10-11 | Format YYYY-MM-DD | Dokter |
| `diagnosa_pemeriksaan` | Catatan hasil diagnosa medis | Demam Flu Ringan | Teks, Data Sensitif | Dokter |
| `qty_detail_tindakan` | Jumlah tindakan yang diberikan | 1 | Angka bulat >= 1 | Perawat / Dokter |
| `tarif_satuan_detail_tindakan` | Tarif tindakan saat transaksi | 50000 | Simpan harga historis | Perawat / Dokter |
| `id_tindakan` | Identifier unik tindakan | 301 | Primary Key, Auto-increment | Kepala Klinik |
| `kd_tindakan` | Kode master tindakan | TND-01 | Alternate Key, Unik | Kepala Klinik |
| `nama_tindakan` | Nama tindakan medis | Pembersihan Luka | Teks | Kepala Klinik |
| `tarif_tindakan` | Tarif acuan master tindakan | 50000 | Angka >= 0 | Kepala Klinik |
| `qty_resep_detail` | Jumlah obat yang diresepkan | 2 | Maksimal 11 item per resep | Dokter / Apoteker |
| `aturan_pakai_resep_detail` | Petunjuk dosis pemakaian obat | 3x1 Hari Sesudah Makan| Teks | Dokter / Apoteker |
| `id_obat` | Identifier unik obat | 401 | Primary Key, Auto-increment | Apoteker |
| `kd_obat` | Kode master persediaan obat | OBT-01 | Alternate Key, Unik | Apoteker |
| `nama_obat` | Nama persediaan obat | Paracetamol 500mg | Teks | Apoteker |
| `stok_obat` | Sisa kuantitas stok obat | 100 | Angka bulat >= 0 | Apoteker |

---

## 9. Kebutuhan Non-Fungsional & Perhitungan Parameter $P$

### A. Perhitungan Parameter $P$
- **Digit NIM:** `25430026` (2 digit terakhir = `26`).
- **Perhitungan $P$:** $P = (26 \pmod 9) + 1 = 8 + 1 = 9$.
- **Batas Maksimal Item Obat per Resep:** $P + 2 = 9 + 2 = 11\text{ item}$.
- **Besar Denda Keterlambatan Tagihan:** $P = \text{Rp9.000 per hari}$.
- **Perkiraan Volume Transaksi Harian:** $40 + (5 \times P) = 40 + (5 \times 9) = 85\text{ transaksi per hari}$.

### B. Retensi Data & Estimasi Volume
- Data rekam medis dan transaksi wajib disimpan sekurang-kurangnya **10 tahun**.
- Estimasi pertumbuhan volume data: $85\text{ transaksi/hari} \times 365\text{ hari} = 31.025\text{ rekam transaksi/tahun}$.

### C. Hak Akses & Privasi Data
- **Data Sensitif:** `nik_pasien`, `no_hp_pasien`, dan `diagnosa_pemeriksaan`.
- **Aturan Akses:**
  - **Resepsionis:** Dapat mencatat dan melihat `pasien` serta `pendaftaran`, tidak dapat membaca `diagnosa_pemeriksaan`.
  - **Dokter:** Memiliki akses membaca/menulis `pemeriksaan`, `detail_tindakan`, dan `resep_detail`.
  - **Apoteker:** Berhak membaca `resep_detail` serta memperbarui `stok_obat`.