# Identitas Mahasiswa

1. Nama    : **Yehezkiel Gustav Setiawan Sitanggang**
2. NIM     : **241401070**
3. Lab     : **Pemrograman Mobile 2**

---

# Aplikasi Kuis Pilihan Ganda

Aplikasi kuis interaktif berbasis Flutter yang dikembangkan dengan antarmuka minimalis, responsif di berbagai orientasi dan resolusi layar, mendukung pergantian tema Light/Dark secara reaktif, serta mengadopsi pola arsitektur berbasis state management.

---

## Fitur Utama

1. **Beranda & Validasi Peserta**:
   - Form input nama peserta dengan validasi (tidak boleh kosong, minimal 2 karakter, trim whitespace otomatis).
   - Info ringkas fitur kuis.
   - Toggle tema Light / Dark di AppBar.

2. **Pengerjaan Kuis Interaktif**:
   - Header progres real-time (`ProgressHeader`) yang menampilkan nomor soal, progress bar, persentase kemajuan, dan jumlah soal yang telah dijawab.
   - Kartu soal (`QuestionCard`) dengan tipografi jelas dan nomor pertanyaan.
   - Pilihan jawaban (`AnswerOptionTile`) interaktif dengan badge A-D, highlight visual saat dipilih, dan kemampuan mengubah jawaban sebelum submit.
   - Navigasi maju-mundur antar soal ("Sebelumnya" & "Selanjutnya"), serta tombol "Selesai" pada nomor terakhir.
   - Dialog peringatan konfirmasi jika pengguna ingin submit namun masih ada soal yang belum terjawab.
   - Dialog proteksi keluar kuis (`PopScope`) untuk mencegah progres hilang tanpa sengaja saat menekan tombol kembali.

3. **Layar Hasil Akhir & Evaluasi**:
   - Ilustrasi visual dinamis sesuai persentase nilai (Trophy, Medal, Try Again).
   - Pesan motivasi evaluasi bertingkat (Sempurna, Luar biasa, Bagus, Cukup baik, Jangan menyerah).
   - Kartu ringkasan skor (`ScoreCard`):
     - Header nama peserta.
     - Skor perbandingan (misal: `8 / 10`) dan persentase nilai (misal: `80%`).
     - Rincian statistik jawaban benar, salah, dan terlewat.
   - Tombol aksi cepat:
     - **Ulangi Kuis**: Mereset kuis dan langsung memulai kembali di soal 1 dengan nama yang sama.
     - **Kembali ke Beranda**: Mereset total kuis dan kembali ke layar beranda.

4. **Sistem Tema Dinamis**:
   - Desain minimalis flat berdasar 4 pilar warna (Primary, Background/Surface, Text, Accent).
   - Mode Terang (Light) dan Gelap (Dark) yang beralih secara instan dan reaktif di semua layar melalui `ThemeProvider`.

5. **Responsivitas Penuh (Responsive & Adaptive Layout)**:
   - Aman diuji di berbagai resolusi layar:
     - Compact Mobile Portrait (320x568)
     - Standard Mobile Portrait (390x844)
     - Large Mobile Portrait (412x915)
     - Compact Landscape (568x320)
     - Standard Landscape (844x390)
     - Tablet Portrait (768x1024)
     - Tablet Landscape (1024x768)
   - Seluruh layar menerapkan `SafeArea`, `SingleChildScrollView`, `ConstrainedBox`, dan `LayoutBuilder` untuk mencegah visual overflow (`RenderFlex`).

---

## Struktur Proyek

```
lib/
├── data/
│   └── dummy_questions.dart        
├── models/
│   └── question.dart               
├── providers/
│   ├── quiz_provider.dart          
│   └── theme_provider.dart         
├── screens/
│   ├── home_screen.dart            
│   ├── quiz_screen.dart            
│   └── result_screen.dart          
├── theme/
│   └── app_theme.dart              
├── widgets/
│   ├── answer_option_tile.dart      
│   ├── custom_text_field.dart      
│   ├── primary_button.dart         
│   ├── progress_header.dart        
│   ├── question_card.dart          
│   └── score_card.dart              
└── main.dart                       
```

---


## Cara Menjalankan Proyek

1. **Install dependensi**:
   ```bash
   flutter pub get
   ```

2. **Jalankan analisis kode (linter)**:
   ```bash
   flutter analyze
   ```

3. **Jalankan aplikasi di emulator / device**:
   ```bash
   flutter run
   ```

   ---

# Dokumentasi

1. Font   : Font Poppins dari Google Fonts https://fonts.google.com/specimen/Poppins?preview.lang=en_Latn
2. Icon   : Material Icon Flutter
3. Image  : https://drive.google.com/drive/folders/12HDOHFoF6tLuxu2zS2f3w0EMVq4aEqpG?usp=sharing
4. Mockup : https://www.figma.com/design/RHIXElSPVUQulfMEhYclBH/Untitled?node-id=0-1&t=6YJ874nkf2gk6weV-1

---

# Tampilan Aplikasi!

Tampilan Beranda

<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 29" src="https://github.com/user-attachments/assets/f41c4c1b-23fc-4858-9c6a-88a1b4c3d362" />
<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 30" src="https://github.com/user-attachments/assets/b6a0b511-98e1-4109-a8d0-6e274768e603" />

Tampilan Kuis
<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 30 (2)" src="https://github.com/user-attachments/assets/4541fe09-43c2-4e39-97a3-de1b512360a1" />
<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 30 (1)" src="https://github.com/user-attachments/assets/9a772a7e-9585-4f0f-b1cc-9f6e392e2fca" />

Tampilan Hasil Kuis
<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 31 (1)" src="https://github.com/user-attachments/assets/3b392b9a-c6a2-4554-b3cb-8e6bae79c3ba" />
<img width="720" height="1600" alt="WhatsApp Image 2026-10-19 at 21 29 31" src="https://github.com/user-attachments/assets/1656f5e3-46e7-4692-95ec-30e1365522a4" />


