# Quiz Umum - Aplikasi Kuis Pengetahuan Umum

Aplikasi kuis interaktif berbasis Flutter yang dikembangkan dengan antarmuka minimalis, responsif di berbagai orientasi dan resolusi layar, mendukung pergantian tema Light/Dark secara reaktif, serta mengadopsi pola arsitektur berbasis state management.

---

##  Fitur Utama

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

## 📂 Struktur Proyek

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


## 🚀 Cara Menjalankan Proyek

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
