part of 'pages.dart';

class MutasiPage extends StatefulWidget {
  const MutasiPage({super.key});

  @override
  _MutasiPageState createState() => _MutasiPageState();
}

class _MutasiPageState extends State<MutasiPage> {
  // Data mutasi yang akan ditampilkan
  List<Map<String, dynamic>> _mutasiData = [
    // Contoh data mutasi
    {
      'Id': 1,
      'Account_Id': 'ACC12345',
      'Transaction_Category': 'Deposit',
      'Amount': 100000,
      'Time_Stamp': '2024-11-01 10:00:00',
    },
    {
      'Id': 2,
      'Account_Id': 'ACC54321',
      'Transaction_Category': 'Withdraw',
      'Amount': 50000,
      'Time_Stamp': '2024-11-02 12:30:00',
    },
  ];

  // Menambahkan mutasi baru ke dalam daftar
  void _addMutasi(Map<String, dynamic> newMutasi) {
    setState(() {
      _mutasiData.add(newMutasi);
    });
  }

  // Menghapus mutasi dari daftar
  void _deleteMutasi(int index) {
    setState(() {
      _mutasiData.removeAt(index);
    });
  }

  // Menampilkan dialog konfirmasi sebelum menghapus mutasi
  Future<void> _showDeleteConfirmationDialog(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data mutasi ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteMutasi(index); // Menghapus mutasi setelah konfirmasi
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2DAD7), // Latar belakang warna beige
      appBar: AppBar(
        title: const Text(
          'Mutasi Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF6582AE), // Warna biru gelap
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Transaksi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6582AE),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _mutasiData.length,
                itemBuilder: (context, index) {
                  final mutasi = _mutasiData[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: const Color(0xFFF5ECED),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow('ID', mutasi['Id'].toString()),
                          const SizedBox(height: 5),
                          _buildRow('Account ID', mutasi['Account_Id']),
                          const SizedBox(height: 5),
                          _buildRow('Transaction Category', mutasi['Transaction_Category']),
                          const SizedBox(height: 5),
                          _buildRow('Amount', 'Rp ${mutasi['Amount']}'),
                          const SizedBox(height: 5),
                          _buildRow('Timestamp', mutasi['Time_Stamp']),
                          const SizedBox(height: 10),
                          // Tombol Hapus untuk menghapus data mutasi
                         ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(index); // Menampilkan konfirmasi hapus
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Warna tombol merah
                            ),
                            child: const Text('Hapus Mutasi'),
                          )

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Tombol Tambah yang akan menavigasi ke halaman AddMutasiPage
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, '/addmutasi');
                  if (result != null) {
                    _addMutasi(result as Map<String, dynamic>);
                  }
                },
                child: const Text('Tambah Mutasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6582AE), // Warna tombol biru
                  minimumSize: const Size(double.infinity, 50), // Ukuran tombol
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6582AE),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF7FA1C4),
          ),
        ),
      ],
    );
  }
}
