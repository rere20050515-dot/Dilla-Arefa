import 'package:flutter/material.dart';
import 'main.dart';

class LaporanStokPage extends StatelessWidget {
  const LaporanStokPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = DataApp.daftarBarang;

    int totalJenis = data.length;
    int totalStok = data.fold(0, (sum, item) => sum + item.stok);
    int totalNilaiAset = data.fold(0, (sum, item) => sum + (item.harga * item.stok));

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Inventaris',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text('Total Jenis Barang: $totalJenis'),
                  Text('Total Unit Stok: $totalStok Item'),
                  Text('Total Nilai Aset: ${rupiah(totalNilaiAset)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Rincian Stok Barang:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...data.map((b) {
            final statusStok = b.stok <= 5 ? 'Stok Menipis' : 'Aman';
            final warnaStatus = b.stok <= 5 ? Colors.red : Colors.green;

            return Card(
              child: ListTile(
                title: Text('${b.nama} (${b.kode})'),
                subtitle: Text('Sisa Stok: ${b.stok} | Total Nilai: ${rupiah(b.harga * b.stok)}'),
                trailing: Chip(
                  label: Text(statusStok, style: const TextStyle(color: Colors.white)),
                  backgroundColor: warnaStatus,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}