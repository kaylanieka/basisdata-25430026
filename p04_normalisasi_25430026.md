## F. Tugas Mandiri: Milestone Proyek 4 (Klinik Sehat Bersama 026)

**Nama Proyek:** Klinik Sehat Bersama 026 (`klinik_026`)
**NIM:** 25430026

### 1. Titik Awal UNF (Unnormalized Form)
Berdasarkan dokumen sumber **Formulir Lembar Pemeriksaan & Resep Pasien**:
`PEMERIKSAAN_UNF (no_pendaftaran, tgl_pendaftaran, no_rm, nik_pasien, nama_pasien, tgl_lahir_pasien, no_hp_pasien, kd_dokter, sip_dokter, nama_dokter, spesialis_dokter, tarif_konsultasi_dokter, tgl_pemeriksaan, diagnosa_pemeriksaan, { kd_tindakan, nama_tindakan, tarif_tindakan, qty_detail_tindakan, tarif_satuan_detail_tindakan, subtotal_tindakan }, { kd_obat, nama_obat, qty_resep_detail, aturan_pakai_resep_detail }, total_biaya_tindakan, total_biaya_obat, grand_total_pembayaran)`

### 2. Dependensi Fungsional Proyek (FD)
- **FD1:** `no_pendaftaran` -> `tgl_pendaftaran`, `no_rm` (AB-02, AB-03)
- **FD2:** `no_rm` -> `nik_pasien`, `nama_pasien`, `tgl_lahir_pasien`, `no_hp_pasien` (AB-01)
- **FD3:** `kd_dokter` -> `sip_dokter`, `nama_dokter`, `spesialis_dokter`, `tarif_konsultasi_dokter`
- **FD4:** `kd_tindakan` -> `nama_tindakan`, `tarif_tindakan`
- **FD5:** `kd_obat` -> `nama_obat`
- **FD6:** `no_pendaftaran` -> `kd_dokter`, `tgl_pemeriksaan`, `diagnosa_pemeriksaan` (AB-04)
- **FD7:** `(no_pendaftaran, kd_tindakan)` -> `qty_detail_tindakan`, `tarif_satuan_detail_tindakan` (AB-07)
- **FD8:** `(no_pendaftaran, kd_obat)` -> `qty_resep_detail`, `aturan_pakai_resep_detail` (AB-05, AB-08)
- **FD9:** `(qty_detail_tindakan, tarif_satuan_detail_tindakan)` -> `subtotal_tindakan` *(Nilai Turunan)*

---

### 3. Tahapan Normalisasi Proyek

#### A. First Normal Form (1NF)
Meratakan grup berulang dengan Kunci Primer Komposit `(no_pendaftaran, kd_tindakan, kd_obat)`:
`PEMERIKSAAN_1NF (no_pendaftaran, kd_tindakan, kd_obat, tgl_pendaftaran, no_rm, nik_pasien, nama_pasien, tgl_lahir_pasien, no_hp_pasien, kd_dokter, sip_dokter, nama_dokter, spesialis_dokter, tarif_konsultasi_dokter, tgl_pemeriksaan, diagnosa_pemeriksaan, nama_tindakan, tarif_tindakan, qty_detail_tindakan, tarif_satuan_detail_tindakan, subtotal_tindakan, nama_obat, qty_resep_detail, aturan_pakai_resep_detail, total_biaya_tindakan, total_biaya_obat, grand_total_pembayaran)`

#### B. Second Normal Form (2NF)
Menghilangkan ketergantungan parsial pada kunci komposit:
- **pemeriksaan:** (`no_pendaftaran`, `tgl_pendaftaran`, `no_rm`, `nik_pasien`, `nama_pasien`, `tgl_lahir_pasien`, `no_hp_pasien`, `kd_dokter`, `sip_dokter`, `nama_dokter`, `spesialis_dokter`, `tarif_konsultasi_dokter`, `tgl_pemeriksaan`, `diagnosa_pemeriksaan`)
- **detail_tindakan:** (`no_pendaftaran`*, `kd_tindakan`*, `qty_detail_tindakan`, `tarif_satuan_detail_tindakan`)
- **resep_detail:** (`no_pendaftaran`*, `kd_obat`*, `qty_resep_detail`, `aturan_pakai_resep_detail`)
- **tindakan:** (`kd_tindakan`, `nama_tindakan`, `tarif_tindakan`)
- **obat:** (`kd_obat`, `nama_obat`)

#### C. Third Normal Form (3NF)
Menghilangkan ketergantungan transitif antar-atribut bukan kunci dengan menambahkan kunci pengganti `id_*`:
- **pasien:** (`id_pasien`, `no_rm`, `nik_pasien`, `nama_pasien`, `tgl_lahir_pasien`, `no_hp_pasien`)
- **dokter:** (`id_dokter`, `kd_dokter`, `sip_dokter`, `nama_dokter`, `spesialis_dokter`, `tarif_konsultasi_dokter`)
- **pendaftaran:** (`id_pendaftaran`, `no_pendaftaran`, `id_pasien`*, `tgl_pendaftaran`)
- **pemeriksaan:** (`id_pemeriksaan`, `id_pendaftaran`*, `id_dokter`*, `tgl_pemeriksaan`, `diagnosa_pemeriksaan`)
- **detail_tindakan:** (`id_pemeriksaan`*, `id_tindakan`*, `qty_detail_tindakan`, `tarif_satuan_detail_tindakan`)
- **tindakan:** (`id_tindakan`, `kd_tindakan`, `nama_tindakan`, `tarif_tindakan`)
- **resep_detail:** (`id_pemeriksaan`*, `id_obat`*, `qty_resep_detail`, `aturan_pakai_resep_detail`)
- **obat:** (`id_obat`, `kd_obat`, `nama_obat`, `stok_obat`)

#### D. Hasil Pemeriksaan BCNF
Seluruh determinan ($X \rightarrow Y$) pada relasi skema 3NF merupakan kunci kandidat (*superkey*) [contohnya `id_pasien`, `no_rm`, `nik_pasien` pada tabel `pasien`]. Dengan demikian, skema proyek **sudah memenuhi kriteria BCNF**.

---

### 4. Keputusan Penyimpanan Nilai Turunan
1. **`subtotal_tindakan`:** **TIDAK DISIMPAN** di tabel operasional, dihitung secara langsung via kueri `SELECT` (`qty * tarif_satuan`).
2. **`total_biaya_tindakan`, `total_biaya_obat`, `grand_total`:** **TIDAK DISIMPAN**, dihitung menggunakan fungsi agregat `SUM()`.
3. **`tarif_satuan_detail_tindakan`:** **DISIMPAN** di tabel `detail_tindakan` untuk menjaga riwayat tarif transaksi lama saat terjadi penyesuaian harga master tindakan (AB-07).

---

### 5. Catatan Perubahan ERD Proyek
1. ERD konseptual pada Pertemuan 3 sudah selaras dan langsung mencakup entitas asosiatif `detail_tindakan` dan `resep_detail`.
2. Penambahan kunci pengganti `id_*` pada seluruh tabel master dan transaksi sebagai *Primary Key*, serta penetapan kode alami (`no_rm`, `nik_pasien`, `kd_dokter`, `kd_tindakan`, `kd_obat`, `no_pendaftaran`) sebagai *Alternate Key* (`UNIQUE`).