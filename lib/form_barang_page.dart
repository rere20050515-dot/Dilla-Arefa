import 'package:flutter/material.dart';
import 'barang.dart';
import 'main.dart';

class FormBarangPage extends StatefulWidget {
  final Barang? barang;
  const FormBarangPage({super.key, this.barang});

  @override
  State<FormBarangPage> createState() => _FormBarangPageState();
}

class _FormBarangPageState extends State<FormBarangPage> {
  late final kodeC = TextEditingController(text: widget.barang?.kode ?? '');
  late final namaC = TextEditingController(text: widget.barang?.nama ?? '');
  late final kategoriC = TextEditingController(text: widget.barang?.kategori ?? '');
  late final hargaC = TextEditingController(text: widget.barang?.harga.toString() ?? '');
  late final stokC = TextEditingController(text: widget.barang?.stok.toString() ?? '');

  void simpan() {
    final kode = kodeC.text.trim();
    final nama = namaC.text.trim();
    final kategori = kategoriC.text.trim();
    final harga = int.tryParse(hargaC.text);
    final stok = int.tryParse(stokC.text);

    if (kode.isEmpty || nama.isEmpty || kategori.isEmpty || harga == null || stok == null) {
      tampilPesan(context, 'Isi semua kolom dengan benar');
      return;
    }

    if (widget.barang == null) {
      DataApp.daftarBarang.add(
        Barang(
          kode: kode,
          nama: nama,
          kategori: kategori,
          harga: harga,
          stok: stok,
        ),
      );
    } else {
      widget.barang!.kode = kode;
      widget.barang!.nama = nama;
      widget.barang!.kategori = kategori;
      widget.barang!.harga = harga;
      widget.barang!.stok = stok;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.barang != null;
    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Edit Barang' : 'Tambah Barang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: kodeC,
            decoration: const InputDecoration(
              labelText: 'Kode Barang',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: namaC,
            decoration: const InputDecoration(
              labelText: 'Nama Barang',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: kategoriC,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: hargaC,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga (Rp)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: stokC,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stok',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: simpan,
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}