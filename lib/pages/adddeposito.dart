import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';  // Import GetStorage

part of 'pages.dart';

class AddDepositoPage extends StatefulWidget {
  const AddDepositoPage({super.key});

  @override
  _AddDepositoPageState createState() => _AddDepositoPageState();
}

class _AddDepositoPageState extends State<AddDepositoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController();

  String? _selectedDepositoType;

  final List<String> _depositoTypes = [
    'Mini',
    'Maxi',
    'Great',
  ];

  final GetStorage _storage = GetStorage();  // Initialize GetStorage

  void _saveDeposito() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save data to GetStorage
      await _storage.write('deposit_name', _nameController.text);
      await _storage.write('amount', _amountController.text);
      await _storage.write('min_amount', _minAmountController.text);
      await _storage.write('deposit_type', _selectedDepositoType ?? '');  // Ensure a non-null value

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Deposito berhasil ditambahkan'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/detail-deposito',  // Navigate to DetailDepositoPage
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Deposito'),
        backgroundColor: const Color(0xFF6582AE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/deposito', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Deposito',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama deposito tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Jumlah (Rp.)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah (Rp.)',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Harap masukkan angka yang valid';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Minimal Jumlah (Rp.)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    controller: _minAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minimal Jumlah (Rp.)',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Minimal jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Harap masukkan angka yang valid';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _saveDeposito,
                child: const Text(
                  'Simpan Deposito',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6582AE),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
