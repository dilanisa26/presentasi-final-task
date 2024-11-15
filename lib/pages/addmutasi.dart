
part of 'pages.dart';

class AddMutasiPage extends StatefulWidget {
  const AddMutasiPage({super.key});

  @override
  _AddMutasiPageState createState() => _AddMutasiPageState();
}

class _AddMutasiPageState extends State<AddMutasiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _transactionType;
  String? _transactionMode; // Untuk memilih Kredit atau Debit
  
  final List<String> _transactionTypes = ['Setoran', 'Penarikan'];
  final List<String> _transactionModes = ['Kredit', 'Debit'];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());  // Set default tanggal
  }

  void _saveMutasi() {
    if (_formKey.currentState?.validate() ?? false) {
      // Data mutasi yang akan dikirim kembali
      final newMutasi = {
        'Id': DateTime.now().millisecondsSinceEpoch,  // ID bisa menggunakan timestamp
        'Account_Id': 'A123',  // Ganti dengan data yang sesuai
        'Transaction_Category': _transactionType,
        'Amount': int.parse(_amountController.text),
        'In_Out': _transactionMode == 'Kredit' ? 'In' : 'Out',
        'Time_Stamp': _dateController.text,
      };

      // Kembalikan data ke halaman MutasiPage
      Navigator.pop(context, newMutasi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mutasi Deposito'),
        backgroundColor: const Color(0xFF6582AE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
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
              // Jenis Transaksi
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
                  child: DropdownButtonFormField<String>(
                    value: _transactionType,
                    hint: const Text('Pilih Jenis Transaksi'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _transactionType = newValue;
                      });
                    },
                    items: _transactionTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis transaksi harus dipilih';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tanggal
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
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Transaksi',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Jumlah
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // In/Out
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
                child: DropdownButtonFormField<String>(
                  value: _transactionMode,
                  hint: const Text('Pilih Kredit/ Debit'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _transactionMode = newValue;
                    });
                  },
                  items: _transactionModes.map((String mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Transaksi mode harus dipilih';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Center(
                child: ElevatedButton(
                  onPressed: _saveMutasi,
                  child: const Text('Simpan Mutasi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6582AE), // Ganti 'primary' dengan 'backgroundColor'
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
