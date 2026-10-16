# TRACKER PENGEMBANGAN APLIKASI QUIZ UMUM

Dokumen pelacak progres pengerjaan aplikasi "Quiz Umum" untuk tugas lab Pemrograman Mobile.
Pengerjaan dilakukan secara bertahap dan terisolasi untuk memudahkan commit GitHub yang bersih dan stabil di setiap tahap.

---

## Daftar Tahap Pengerjaan

- [x] **Tahap 1: Setup Proyek, Dependensi, Struktur Folder, & Aset Dasar**
  - **Tujuan**: Menambahkan package `provider`, membuat struktur folder lib standar, menyiapkan folder aset (`assets/images/`, `assets/fonts/`), font kustom (Poppins), serta mendaftarkannya pada `pubspec.yaml`.
  - **File yang dibuat/diubah**:
    - `pubspec.yaml`
    - `assets/fonts/` (file font TTF Poppins: Regular, Medium, Bold)
    - `assets/images/` (aset gambar: quiz_logo.png, trophy.png, medal.png, try_again.png)
    - Struktur folder di `lib/` (`models/`, `data/`, `providers/`, `screens/`, `widgets/`, `theme/`)
    - `lib/main.dart` & `test/widget_test.dart`
  - **Kriteria Selesai**: `flutter pub get` berhasil, aset dan dependensi terkonfigurasi tanpa error, project tetap bisa di-build/run.

- [x] **Tahap 2: Sistem Tema (AppTheme) & ThemeProvider**
  - **Tujuan**: Membangun konfigurasi tema Light & Dark terpisah menggunakan `ColorScheme` dan font kustom, serta state management `ThemeProvider` menggunakan `ChangeNotifier`.
  - **File yang dibuat/diubah**:
    - `lib/theme/app_theme.dart`
    - `lib/providers/theme_provider.dart`
    - `lib/main.dart` (setup ThemeProvider awal)
  - **Kriteria Selesai**: Aplikasi dapat dijalankan (`flutter run`), tema Light dan Dark dapat beralih secara reaktif via provider, tidak ada hardcode warna di ThemeData.

- [x] **Tahap 3: Model Soal & Data Dummy Soal**
  - **Tujuan**: Membuat data model `Question` dan kumpulan 10 soal pilihan ganda pengetahuan umum (Bahasa Indonesia) dalam satu list terstruktur.
  - **File yang dibuat/diubah**:
    - `lib/models/question.dart`
    - `lib/data/dummy_questions.dart`
  - **Kriteria Selesai**: Model mencakup teks soal, list 4 opsi jawaban, dan indeks jawaban benar; 10 soal siap diakses tanpa error syntax/linter.

- [x] **Tahap 4: QuizProvider (State Management Kuis)**
  - **Tujuan**: Mengelola state kuis (nama peserta, indeks soal aktif, map/list jawaban terpilih, kalkulasi skor benar & persentase, navigasi antar soal, reset kuis) dengan `ChangeNotifier`.
  - **File yang dibuat/diubah**:
    - `lib/providers/quiz_provider.dart`
    - `lib/main.dart` (mendaftarkan QuizProvider ke MultiProvider)
  - **Kriteria Selesai**: Provider dapat meng-update nama, mencatat dan mengganti jawaban per nomor soal, menghitung skor secara akurat, dan mereset state saat dibutuhkan.

- [x] **Tahap 5: Reusable UI Widgets Fondasi**
  - **Tujuan**: Membuat widget UI umum yang digunakan berulang seperti tombol utama (`PrimaryButton`) dan field input (`CustomTextField`).
  - **File yang dibuat/diubah**:
    - `lib/widgets/primary_button.dart`
    - `lib/widgets/custom_text_field.dart`
  - **Kriteria Selesai**: Widget responsif, mendukung tema (Light/Dark via ColorScheme), aman terhadap batasan layout, dan tidak memiliki error linter.

- [x] **Tahap 6: HomeScreen & Validasi Input Nama**
  - **Tujuan**: Mengimplementasikan tampilan layar utama (`HomeScreen`) yang memuat logo/ilustrasi, input nama peserta (dengan validasi tidak boleh kosong), tombol Mulai, dan toggle tema Dark/Light.
  - **File yang dibuat/diubah**:
    - `lib/screens/home_screen.dart`
    - `lib/main.dart` (menjadikan HomeScreen sebagai home)
  - **Kriteria Selesai**: HomeScreen tampil rapi, input nama tervalidasi sebelum masuk kuis, tombol toggle tema berfungsi langsung di UI, bebas overflow pada mode portrait maupun landscape.

- [x] **Tahap 7: Reusable Widgets Kuis & QuizScreen**
  - **Tujuan**: Mengimplementasikan layar kuis interaktif (`QuizScreen`) dengan komponen `ProgressHeader`, `QuestionCard`, dan `AnswerOptionTile`.
  - **File yang dibuat/diubah**:
    - `lib/widgets/progress_header.dart`
    - `lib/widgets/question_card.dart`
    - `lib/widgets/answer_option_tile.dart`
    - `lib/screens/quiz_screen.dart`
  - **Kriteria Selesai**: Tampil nomor soal & progress bar, teks soal & 4 opsi jawaban, opsi terpilih di-highlight, jawaban bisa diubah sebelum selesai, tombol Sebelumnya/Selanjutnya aktif sesuai posisi soal, tombol Selesai di nomor 10. Bebas overflow saat rotasi layar.

- [ ] **Tahap 8: Reusable Widgets Hasil & ResultScreen**
  - **Tujuan**: Mengimplementasikan layar skor akhir (`ResultScreen`) dengan komponen `ScoreCard`, menampilkan nama peserta, skor (format X/10 & persen %), pesan evaluasi kuis, ilustrasi/ikon hasil, serta tombol "Ulangi Kuis" dan "Kembali ke Beranda".
  - **File yang dibuat/diubah**:
    - `lib/widgets/score_card.dart`
    - `lib/screens/result_screen.dart`
  - **Kriteria Selesai**: Alur lengkap kuis dari Home -> Quiz -> Result berfungsi mulus. Skor dihitung tepat sesuai nama yang dimasukkan. Tombol Ulangi Kuis dan Kembali ke Beranda mereset state kuis dengan benar.

- [ ] **Tahap 9: Polish, Uji Responsivitas (Landscape/Portrait), & Finalisasi**
  - **Tujuan**: Audit menyeluruh kode, memastikan penerapan MediaQuery/LayoutBuilder/SafeArea/SingleChildScrollView di semua screen, pengecekan lint rules (`flutter analyze`), dan finalisasi dokumen tracker.
  - **File yang dibuat/diubah**:
    - Semua file terkait jika ada perbaikan linter/responsivitas
    - `TRACKER.md` (pembaruan status akhir)
  - **Kriteria Selesai**: `flutter analyze` 0 issues, tidak ada visual overflow saat diuji di berbagai ukuran layar dan orientasi, siap di-push ke GitHub untuk pengumpulan tugas.

---

## Log Riwayat Pengerjaan

- **Tahap 1 (Selesai)**:
  - Berhasil menambahkan dependensi `provider: ^6.1.2`.
  - Menyiapkan struktur folder `lib/models/`, `lib/data/`, `lib/providers/`, `lib/screens/`, `lib/widgets/`, `lib/theme/`.
  - Mengunduh dan mendaftarkan font kustom Google Fonts Poppins (Regular, Medium 500, Bold 700) di `assets/fonts/` dan `pubspec.yaml`.
  - Menyiapkan aset visual kuis (`quiz_logo.png`, `trophy.png`, `medal.png`, `try_again.png`) di `assets/images/` dan mendaftarkannya di `pubspec.yaml`.
  - Menguji kompilasi dan smoke test (`flutter test` dan `flutter analyze`). Semua lulus 100% tanpa warning/error.

- **Tahap 2 (Selesai)**:
  - Mengimplementasikan `AppTheme` di `lib/theme/app_theme.dart` dengan desain minimalis 4 warna pilar (Primary, Background/Surface, Text, Accent), tanpa neon glow, tanpa gradasi acak, dan elevasi flat (0) menggunakan border halus.
  - Mengimplementasikan `ThemeProvider` di `lib/providers/theme_provider.dart` dengan `ChangeNotifier` untuk beralih mode tema Light/Dark secara reaktif.
  - Mengintegrasikan `ThemeProvider` ke `lib/main.dart` melalui `MultiProvider` dan `Consumer`, lengkap dengan layar preview minimalis untuk pengujian interaktif tema.
  - Memperbarui widget test `test/widget_test.dart` untuk memverifikasi peralihan tema Light <-> Dark.
  - Menjalankan `flutter test` (100% passed) dan `flutter analyze` (0 issues).

- **Tahap 3 (Selesai)**:
  - Membuat data model `Question` di `lib/models/question.dart` dengan properti `text`, alias getter `question`, `options` (4 pilihan jawaban), `correctAnswerIndex`, serta helper methods `correctAnswer` dan `isCorrect(index)`. Didukung constructor `const` dengan assert validasi rentang indeks.
  - Menyiapkan 10 butir soal pilihan ganda pengetahuan umum (Bahasa Indonesia) di `lib/data/dummy_questions.dart` dengan format terstruktur, opsi unik per soal, dan jawaban akurat (sejarah, geografi, sains, biologi, budaya).
  - Membuat unit test komprehensif di `test/question_test.dart` untuk menguji integritas model dan validitas ke-10 soal dummy.
  - Menguji dengan `flutter analyze` (0 issues) dan `flutter test` (seluruh 6 test case lulus 100%).

- **Tahap 4 (Selesai)**:
  - Mengimplementasikan `QuizProvider` di `lib/providers/quiz_provider.dart` berbasis `ChangeNotifier` untuk mengelola state kuis secara reaktif.
  - Fitur lengkap mencakup: pengelolaan nama peserta (`userName`), indeks soal aktif (`currentQuestionIndex`), nomor soal UI (`currentQuestionNumber`), map jawaban terpilih (`selectedAnswers`), pemilihan & penggantian jawaban (`selectAnswer`, `selectAnswerFor`), navigasi soal (`nextQuestion`, `previousQuestion`, `goToQuestion`, batas pergerakan), pengecekan status (`isQuestionAnswered`, `hasAnsweredCurrent`, `isAllAnswered`), progres pengerjaan (`progress`), kalkulasi nilai akurat (`score`, `correctAnswersCount`, `wrongAnswersCount`, `unansweredCount`, `scorePercentage`, `scorePercentageFormatted`), pesan evaluasi dinamis (`resultMessage`, `resultImagePath`), serta fungsi penyelesaian & reset kuis (`completeQuiz`, `restartQuiz`, `resetQuiz`).
  - Mendaftarkan `QuizProvider` ke dalam `MultiProvider` pada `lib/main.dart`.
  - Menulis test suite komprehensif di `test/quiz_provider_test.dart` mencakup 10 skenario pengujian unit (state awal, trim nama, navigasi & batasan indeks, pemilihan & pergantian jawaban, kalkulasi skor persentase & evaluasi bertingkat, penanda penyelesaian, restart kuis vs reset total).
  - Melakukan verifikasi dengan `flutter analyze` (0 issues) dan `flutter test` (seluruh 17 test case lulus 100%).

- **Tahap 5 (Selesai)**:
  - Mengimplementasikan `PrimaryButton` di `lib/widgets/primary_button.dart` dengan dua varian (filled dan outlined via constructor `PrimaryButton.outlined`), penanganan status loading (`isLoading` dengan spinner `CircularProgressIndicator`), ikon opsional, tinggi standar 50px (memenuhi standar minimum touch target), dan proteksi overflow horizontal (`Flexible` + `TextOverflow.ellipsis`).
  - Mengimplementasikan `CustomTextField` di `lib/widgets/custom_text_field.dart` dengan label bersih di atas kolom input, integrasi tema Light/Dark yang mulus, validasi form (`validator` & `errorText`), dukungan tombol pembersih teks otomatis (`showClearButton`), ikon prefix/suffix, serta kustomisasi keyboard dan kapitalisasi.
  - Menulis test suite komprehensif di `test/widgets_test.dart` mencakup 11 skenario pengujian widget untuk `PrimaryButton` (render label, tap callback, status disabled saat null/loading, ikon, varian outlined) dan `CustomTextField` (label & placeholder, pengetikan teks & onChanged callback, clear button, prefix & suffix icons, form validation error, explicit error text).
  - Melakukan verifikasi dengan `flutter analyze` (0 issues) dan `flutter test` (seluruh 28 test case pada proyek lulus 100%).

- **Tahap 6 (Selesai)**:
  - Mengimplementasikan `HomeScreen` di `lib/screens/home_screen.dart` dengan logo kuis (`quiz_logo.png`), judul & deskripsi informatif, deretan info fitur (10 Soal, 4 Pilihan, Skor Akurat), kartu input nama dengan `CustomTextField` & `PrimaryButton`, serta toggle tema (Light/Dark) di AppBar.
  - Menerapkan validasi form ketat: pengecekan input kosong, penolakan spasi saja (whitespace trimming), dan panjang minimal nama (minimal 2 karakter) sebelum dapat memulai kuis.
  - Mengintegrasikan `HomeScreen` ke `QuizProvider` untuk menyimpan nama peserta (`setUserName`) dan mereset status pengerjaan kuis (`restartQuiz`) saat memulai.
  - Menyiapkan placeholder layar tujuan `QuizScreen` di `lib/screens/quiz_screen.dart` sebagai target navigasi dari `HomeScreen` menuju pengerjaan kuis pada Tahap 7.
  - Memperbarui `lib/main.dart` dengan mengganti preview sementara dengan `HomeScreen` sebagai root layar `MyApp`.
  - Menulis test suite komprehensif di `test/home_screen_test.dart` (12 skenario pengujian widget) dan memperbarui `test/widget_test.dart` untuk menguji UI rendering, toggle tema, validasi form, submit via keyboard/tombol, pembersihan teks via clear button, serta uji responsivitas layout (portrait, landscape, small screen) tanpa visual overflow.
  - Melakukan verifikasi dengan `flutter analyze` (0 issues) dan `flutter test` (seluruh 40 test case pada proyek lulus 100%).

- **Tahap 7 (Selesai)**:
  - Mengimplementasikan `ProgressHeader` di `lib/widgets/progress_header.dart` untuk menampilkan nomor soal aktif, total soal, persentase kemajuan kuis, jumlah pertanyaan yang sudah terjawab, serta `LinearProgressIndicator` responsif bebas overflow di segala ukuran layar.
  - Mengimplementasikan `QuestionCard` di `lib/widgets/question_card.dart` dengan kartu minimalis bergaris tepi halus, nomor pertanyaan, kategori opsional, dan tipografi teks soal yang nyaman dibaca.
  - Mengimplementasikan `AnswerOptionTile` di `lib/widgets/answer_option_tile.dart` dengan badge huruf (A, B, C, D), animasi transisi pemilihan jawaban, penyorotan visual aktif (highlight background, border, dan check icon), efek sentuhan ripple (`InkWell`), serta proteksi text wrapping tanpa visual overflow.
  - Mengimplementasikan layar kuis interaktif `QuizScreen` di `lib/screens/quiz_screen.dart` yang mengintegrasikan `ProgressHeader`, `QuestionCard`, 4 `AnswerOptionTile`, navigasi tombol dinamis ("Sebelumnya" dan "Selanjutnya" / "Selesai" pada nomor 10), toggle tema Light/Dark langsung di AppBar, proteksi dialog konfirmasi saat menekan tombol kembali, dan dialog peringatan konfirmasi jika terdapat soal yang belum terjawab sebelum submit.
  - Menyiapkan placeholder `ResultScreen` di `lib/screens/result_screen.dart` untuk target navigasi saat kuis diselesaikan, siap untuk implementasi lengkap pada Tahap 8.
  - Menulis test suite komprehensif:
    - `test/quiz_widgets_test.dart` (11 skenario pengujian unit & widget untuk `ProgressHeader`, `QuestionCard`, dan `AnswerOptionTile`).
    - `test/quiz_screen_test.dart` (12 skenario pengujian widget untuk `QuizScreen`: render UI awal, tombol Sebelumnya disabled di nomor 1, pemilihan & pergantian jawaban, navigasi maju-mundur, perubahan tombol menjadi "Selesai" di nomor 10, peringatan belum terjawab, submit kuis, konfirmasi keluar AppBar, toggle tema, dan uji responsivitas portrait, landscape, serta compact screen bebas overflow).
  - Melakukan verifikasi dengan `flutter analyze` (0 issues) dan `flutter test` (seluruh 63 test case pada proyek lulus 100%).
