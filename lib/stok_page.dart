import 'package:flutter/material.dart';
import 'barang.dart';
import 'form_barang_page.dart';
import 'main.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  String kataKunci = '';

  Future<void> bukaForm({Barang? barang}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormBarangPage(barang: barang)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasilCari = DataApp.daftarBarang.where((b) {
      final query = kataKunci.toLowerCase();
      return b.nama.toLowerCase().contains(query) ||
          b.kode.toLowerCase().contains(query) ||
          b.kategori.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (val) => setState(() => kataKunci = val),
              decoration: const InputDecoration(
                hintText: 'Cari barang (nama, kode, kategori)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: hasilCari.isEmpty
                ? const Center(child: Text('Barang tidak ditemukan'))
                : ListView.builder(
                    itemCount: hasilCari.length,
                    itemBuilder: (context, i) {
                      final b = hasilCari[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text('${b.nama} (${b.kode})',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Kategori: ${b.kategori}\n${rupiah(b.harga)}  •  Stok: ${b.stok}'),
                          onTap: () => bukaForm(barang: b),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => DataApp.daftarBarang.remove(b));
                              tampilPesan(context, '${b.nama} dihapus');
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}