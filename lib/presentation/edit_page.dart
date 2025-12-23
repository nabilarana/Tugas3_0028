import 'package:flutter/material.dart';
import 'package:moneyappsqflite/data/db/transaction_dao.dart';
import 'package:moneyappsqflite/data/model/transaction.dart';

class EditPage extends StatefulWidget {
  final Transaction ts;
  const EditPage({super.key, required this.ts});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<String> category = [
    'Gaji',
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Belanja',
    'Lainnya',
  ];

  final _formKey = GlobalKey<FormState>();
  final _categoryCtrl = TextEditingController();
  final _descripCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _type = 'income';
  DateTime _selectedDate = DateTime.now();
  final _dao = TransactionDao();

  @override
  void initState() {
    super.initState();
    _type = widget.ts.type;
    _categoryCtrl.text = widget.ts.category;
    _amountCtrl.text = widget.ts.amount.toString();
    _descripCtrl.text = widget.ts.description;
    _selectedDate = DateTime.parse(widget.ts.date);
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _descripCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text) ?? 0.0;

    final tx = Transaction(
      type: _type,
      category: _categoryCtrl.text.trim(),
      description: _descripCtrl.text.trim(),
      amount: amount,
      date: _selectedDate.toIso8601String(),
    );

    await _dao.updateTransaction(widget.ts.id!, tx);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'income'),
                decoration: const InputDecoration(labelText: 'Tipe'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoryCtrl.text,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: category
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (v) => _categoryCtrl.text = v ?? '',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Pilih kategori' : null,
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _descripCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Masukan deskripsi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Masukkan nominal';
                  final n = double.tryParse(v);
                  if (n == null) return 'Masukkan angka yang valid';
                  if (n <= 0) return 'Nominal harus lebih besar dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${_selectedDate.toLocal().toString().split('T').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
