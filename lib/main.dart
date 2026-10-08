import 'package:flutter/material.dart';
import 'barang.dart';
import 'stok_page.dart';
import 'laporan_stok_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventaris Barang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 52, 2, 32), useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

class Penjualan {
  final String namaBarang;
  final int jumlah;
  final int total;
  final DateTime waktu;
  Penjualan(this.namaBarang, this.jumlah, this.total, this.waktu);
}

class DataApp {
  static String username = 'kosmetik';
  static String password = '12345678';

  static List<Barang> daftarBarang = [
    Barang(kode: 'B001', nama: 'lip oil', kategori: 'kosmetik', harga: 50000, stok: 50),
    Barang(kode: 'B002', nama: 'lip balm', kategori: 'kosmetik', harga: 24000, stok: 100),
    Barang(kode: 'B003', nama: 'lip cream', kategori: 'kosmetik', harga: 21000, stok: 230),
    Barang(kode: 'B004', nama: 'lip serum', kategori: 'kosmetik', harga: 27000, stok: 240),
    Barang(kode: 'B005', nama: 'serum', kategori: 'skincare', harga: 57000, stok: 930),
    

  ];
  static List<Penjualan> riwayat = [];
}

String rupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

void tampilPesan(BuildContext context, String pesan) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userC = TextEditingController();
  final passC = TextEditingController();
  bool sembunyikan = true;

  void login() {
    if (userC.text == DataApp.username && passC.text == DataApp.password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      tampilPesan(context, 'Username atau password salah!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.inventory_2, size: 80, color: Color.fromARGB(255, 244, 246, 246)),
              const SizedBox(height: 8),
              const Text('Inventaris Barang',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: userC,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passC,
                obscureText: sembunyikan,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(sembunyikan ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => sembunyikan = !sembunyikan),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: login,
                  child: const Text('LOGIN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabAktif = 0;

  final judul = ['Stok Barang', 'Laporan Stok', 'Penjualan', 'Akun'];

  Widget halaman() {
    switch (tabAktif) {
      case 0:
        return const StokPage();
      case 1:
        return const LaporanStokPage();
      case 2:
        return const JualPage();
      default:
        return const AkunPage();
    }
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul[tabAktif]),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar',
              onPressed: logout),
        ],
      ),
      body: halaman(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabAktif,
        onDestinationSelected: (i) => setState(() => tabAktif = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.inventory), label: 'Stok'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Laporan'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Jual'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}

class JualPage extends StatefulWidget {
  const JualPage({super.key});

  @override
  State<JualPage> createState() => _JualPageState();
}

class _JualPageState extends State<JualPage> {
  Barang? dipilih;
  final jumlahC = TextEditingController();

  void jual() {
    final jumlah = int.tryParse(jumlahC.text);

    if (dipilih == null || jumlah == null || jumlah <= 0) {
      tampilPesan(context, 'Pilih barang dan isi jumlah dengan benar');
      return;
    }
    if (jumlah > dipilih!.stok) {
      tampilPesan(context, 'Stok tidak cukup! Sisa: ${dipilih!.stok}');
      return;
    }

    final total = dipilih!.harga * jumlah;
    setState(() {
      dipilih!.stok -= jumlah;
      DataApp.riwayat.insert(
        0,
        Penjualan(dipilih!.nama, jumlah, total, DateTime.now()),
      );
    });
    tampilPesan(context, 'Terjual! Total ${rupiah(total)}');
    jumlahC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<Barang>(
          value: dipilih,
          decoration: const InputDecoration(
              labelText: 'Pilih Barang', border: OutlineInputBorder()),
          items: DataApp.daftarBarang
              .map((b) => DropdownMenuItem(
                    value: b,
                    child: Text('${b.nama} (stok ${b.stok})'),
                  ))
              .toList(),
          onChanged: (b) => setState(() => dipilih = b),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: jumlahC,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: 'Jumlah', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: jual,
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text('JUAL'),
        ),
      ],
    );
  }
}

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final lamaC = TextEditingController();
  final baruC = TextEditingController();
  final konfirmC = TextEditingController();

  void ubahPassword() {
    if (lamaC.text != DataApp.password) {
      tampilPesan(context, 'Password lama salah');
    } else if (baruC.text.length < 4) {
      tampilPesan(context, 'Password baru minimal 4 karakter');
    } else if (baruC.text != konfirmC.text) {
      tampilPesan(context, 'Konfirmasi password tidak sama');
    } else {
      DataApp.password = baruC.text;
      lamaC.clear();
      baruC.clear();
      konfirmC.clear();
      tampilPesan(context, 'Password berhasil diubah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Login sebagai: ${DataApp.username}',
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 24),
        const Text('Ubah Password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: lamaC,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'Password Lama', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: baruC,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'Password Baru', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: konfirmC,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'Ulangi Password Baru', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        FilledButton(onPressed: ubahPassword, child: const Text('SIMPAN PASSWORD')),
      ],
    );
  }
}