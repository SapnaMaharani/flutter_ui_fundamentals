# Course Explorer v2

## Arsitektur dan Tanggung Jawab Layer (Separation of Concerns)

- **models/**: Berisi struktur data (blueprint) aplikasi, seperti `Course`.
- **services/**: Bertugas mengambil data mentah dari sumber data (JSON/API). Sama sekali tidak memuat UI/Widget.
- **repositories/**: Bertindak sebagai perantara yang mengolah data dari Service agar siap dikonsumsi oleh Provider.
- **providers/**: Bertanggung jawab mengelola *state* (status *loading*, *error*, data, dan *favorites*) menggunakan `ChangeNotifier`. Tidak menyimpan `BuildContext`.
- **screens/**: Berisi antarmuka pengguna (UI). Hanya bertugas merender tampilan berdasarkan *state* dari Provider dan menangani interaksi pengguna.
- **widgets/**: Berisi potongan-potongan UI yang dapat digunakan kembali (*reusable*) di berbagai *screens*.